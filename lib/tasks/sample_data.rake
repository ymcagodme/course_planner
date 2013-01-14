namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_roles
    make_users
    Rake::Task['db:test:prepare'].invoke
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
