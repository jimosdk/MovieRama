# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  password_digest :string           not null
#  session_token   :string           not null
#  username        :string           not null
#
# Indexes
#
#  index_users_on_session_token  (session_token) UNIQUE
#  index_users_on_username       (username) UNIQUE
#
class User < ApplicationRecord
    attr_reader :password 

    validates :username, :password_digest, :session_token , presence: true
    validates :username, uniqueness: {message: "has already been taken"}
    validates :session_token, uniqueness: true
    validates :password, length: {minimum: 6, allow_nil: true}

    after_initialize :ensure_session_token

    has_many :posts,
        foreign_key: :poster_id,
        class_name: :Movie,
        dependent: :destroy

    has_many :ratings,
        foreign_key: :user_id,
        dependent: :destroy

    has_many :likes,
        ->(rating){where(value: 'like')},
        foreign_key: :user_id,
        class_name: :Rating

    has_many :hates,
        ->(rating){where(value: 'hate')},
        foreign_key: :user_id,
        class_name: :Rating

    

   def self.find_by_credentials(username,password)
        user = User.find_by(username: username)
        user && user.is_password?(password) ? user : nil 
    end

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def reset_session_token!
        self.session_token = User.generate_session_token 
        self.session_token = User.generate_session_token while User.where.not(id: self.id).exists?(session_token: self.session_token)
        self.save!
        self.session_token
    end

    def likes?(post)
        likes.joins(:post).exists?(post_id: post.id,value: 'like')
    end

    def hates?(post)
        hates.joins(:post).exists?(post_id: post.id,value: 'hate')
    end

    def post_rating(movie)
        ratings.where(post_id: movie.id).pluck(:value).first
    end

    def self.own_post(user_id,post_id)
        joins(:posts).exists?(movies: {id: post_id},id: user_id)
    end

    private 

    def self.generate_session_token
        SecureRandom.urlsafe_base64(16)
    end

    def ensure_session_token 
        self.session_token ||= User.generate_session_token 
        self.session_token = User.generate_session_token while User.where.not(id: self.id).exists?(session_token: self.session_token)
        self.session_token
    end
    
end
