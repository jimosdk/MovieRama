# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
ActiveRecord::Base.transaction do 
    User.destroy_all

    10.times do 
        begin
           User.create!(username: Faker::Name.name,password:'123456') 
        rescue #=> exception
        end
    end
    
    users = User.all

    15.times do 
        begin
           Movie.create!(title: Faker::Movie.title,description:'Lorem ipsum dolor sit amet, 
                    consectetuer adipiscing elit. Maecenas porttitor congue massa. Fusce posuere, magna sed pulvinar 
                    ultricies, purus lectus malesuada libero, sit amet commodo magna eros quis urna. Nunc viverra imperdiet enim. Fusce est. 
                    Vivamus a tellus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',poster_id:users.sample.id) 
        rescue #=> exception
        end
    end

    users.each do |user|
        Movie.all.each do |movie|
            next unless rand(1..10) > 7
            begin
                Rating.create!(post_id: movie.id,user_id:user.id,value: ['like','hate'].sample)
            rescue 
            end
        end
    end
end
