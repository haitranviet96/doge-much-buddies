namespace :fill do
  desc 'Fill data'
  task data: :environment do
    require 'faker'
    puts 'Erasing existing data'
    puts '====================='

    [User, Post, Event, Comment].each(&:delete_all)
    ActsAsVotable::Vote.delete_all
    PublicActivity::Activity.delete_all

    puts 'Creating users'
    puts '=============='
    genders = ['male', 'female']
    password = '12345678'

    20.times do
      user = User.new(password: password)
      user.name = Faker::Name.name
      user.email = Faker::Internet.email
      user.sex = genders
      user.dob = Faker::Date.between(45.years.ago, 15.years.ago)
      user.phone_number = Faker::PhoneNumber.cell_phone
      user.confirmed_at = DateTime.now
      user.sign_in_count = 0
      user.posts_count = 0
      user.save!
      puts "created user #{user.name}"
    end


    user = User.new(name: 'Doge', email: 'test@doge.com', sex: 'male', password: '12345678')
    user.save!
    puts 'Created test user with email=test@doge.com and password=12345678'

    puts 'Generate Friendly id slug for users'
    puts '==================================='
    User.find_each(&:save)

    puts 'Creating Posts'
    puts '=============='
    users = User.all

    15.times do
      post = Post.new
      post.content = Populator.sentences(2..4)
      post.user = users.sample
      post.save!
      puts "created post #{post.id}"
    end

    puts 'Creating Comments For Posts'
    puts '==========================='

    posts = Post.all

    15.times do
      post = posts.sample
      user = users.sample
      comment = post.comments.new
      comment.comment = Populator.sentences(1)
      comment.user = user
      comment.save
      puts "user #{user.name} commented on post #{post.id}"
    end

    puts 'Creating Events'
    puts '==============='

    15.times do
      event = Event.new
      event.name = Populator.words(1..3).titleize
      event.event_datetime = Faker::Date.between(2.years.ago, 1.day.from_now)
      event.user = users.sample
      event.save
      puts "created event #{event.name}"
    end

    puts 'Creating Likes For Posts'
    puts '========================'

    15.times do
      post = posts.sample
      user = users.sample
      post.liked_by user
      puts "post #{post.id} liked by user #{user.name}"
    end

    puts 'Creating Likes For Events'
    puts '========================='
    events = Event.all

    15.times do
      event = events.sample
      user = users.sample
      event.liked_by user
      puts "event #{event.id} liked by user #{user.name}"
    end

    puts 'Creating Comments For Events'
    puts '============================='

    15.times do
      event = events.sample
      user = users.sample
      comment = event.comments.new
      comment.commentable_type = 'Event'
      comment.comment = Populator.sentences(1)
      comment.user = user
      comment.save
      puts "user #{user.name} commented on event #{event.id}"
    end

  end
end
