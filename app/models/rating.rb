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
    validates :user_id, uniqueness: {scope: :post_id}#,message: "has already #{self.value}d this post"}
    validate  :not_own_post

    belongs_to :post,
        class_name: :Movie

    belongs_to :user

    def not_own_post
        own_post = Movie.exists?(id: self.post_id,poster_id: self.user_id)
        errors.add(:base,"You can not rate your own post") if own_post
    end

end
