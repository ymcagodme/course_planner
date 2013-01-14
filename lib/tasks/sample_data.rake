namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_roles
    make_users
    make_courses
    Rake::Task['db:test:prepare']
    FileUtils.touch "#{Rails.root}/tmp/restart.txt"
  end
end

def make_roles
  YAML.load(ENV['ROLES']).each do |role|
    Role.find_or_create_by_name({ :name => role }, :without_protection => true)
    puts 'role: ' << role
  end
end

def make_users
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@gmail.com"
    password = "password"
    user = User.new(:name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
    user.skip_confirmation!
    user.add_role :user
    user.save!
    puts 'Add user: ' << user.name
  end
end

STATUS = %w[OPEN CLOSE TENTATIVE WAITLIST CANCELLED]
def make_courses
  100.times do |n|
    number = (10000 + 100 * n + Random.rand(0..99)).to_s
    title = Faker::Lorem.sentence(3)
    instructor = Faker::Name.name
    status = STATUS[Random.rand(0..4)]
    available_seats = Random.rand(1..30)
    term = 1131
    Course.create!(
      number: number,
      title:  title,
      instructor: instructor,
      status: status,
      available_seats: available_seats,
      term: term
    )
    puts "Add course: #{number} (#{title})"
  end
end