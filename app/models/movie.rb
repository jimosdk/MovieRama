# == Schema Information
#
# Table name: movies
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  poster_id   :bigint           not null
#
# Indexes
#
#  index_movies_on_poster_id            (poster_id)
#  index_movies_on_title_and_poster_id  (title,poster_id) UNIQUE
#
require 'action_view'

class Movie < ApplicationRecord

    include ActionView::Helpers::DateHelper

    validates :title,:description, presence: true
    validates :title, uniqueness: {scope: :poster_id, message: "has already been used in another of your posts"}

    belongs_to :poster,
        class_name: :User

    has_many :ratings,
        foreign_key: :post_id,
        dependent: :destroy

    has_many :likes,
        ->(rating){where(value: 'like')},
        foreign_key: :post_id,
        class_name: :Rating

    has_many :hates,
        ->(rating){where(value: 'hate')},
        foreign_key: :post_id,
        class_name: :Rating

    def self.sort_based_on_rating(field,order)
        joins(<<-SQL)
            LEFT OUTER JOIN 
            (SELECT movies.id AS id,COUNT(*) AS num 
            FROM movies 
            INNER JOIN ratings 
            ON movies.id = ratings.post_id 
            WHERE ratings.value = '#{field}' 
            GROUP BY movies.id) AS counts 
            ON movies.id = counts.id
        SQL
        .group("movies.id,counts.id,counts.num").
        order("COALESCE(counts.num,0) #{order.upcase}")
    end

    def number_of_likes
        likes.size
    end

    def number_of_hates
        hates.size
    end

    def date_posted
        time_ago_in_words(self.created_at) + " ago"
    end
end
