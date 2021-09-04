# == Schema Information
#
# Table name: ratings
#
#  id      :bigint           not null, primary key
#  value   :string           not null
#  post_id :bigint           not null
#  user_id :bigint           not null
#
# Indexes
#
#  index_ratings_on_post_id              (post_id)
#  index_ratings_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
class Rating < ApplicationRecord
    OPTIONS = %w(like hate)

    validates :value, presence: true
    validates :value, inclusion: OPTIONS
    validates :user_id, uniqueness: {scope: :post_id,message: "has already rated this post"}
    validate  :not_own_post

    belongs_to :post,
        class_name: :Movie

    belongs_to :user


    private

    def not_own_post
        if User.find_by(id: self.user_id).own_post(self.post_id)
            errors.add(:base,"You can not rate your own post") 
        end
    end
end
