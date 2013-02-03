namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_roles
    make_users
    make_term_and_courses
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
def make_term_and_courses
  term = Term.create!(code: 1131, year: 2013, season: Term::VALID_SEASON[0])
  department = Department.create!(abbr: "CIS", name: "Computer and Information Seciences")
  100.times do |n|
    code = (10000 + 100 * n + Random.rand(0..99)).to_s
    number = (100 * Random.rand(1..8)).to_s
    title = Faker::Lorem.sentence(3)
    instructor = Faker::Name.name
    status = Course::VALID_STATUS[Random.rand(0..4)]
    available_seats = Random.rand(1..30)
    term.courses.create(
      code: code,
      number: number,
      title:  title,
      instructor: instructor,
      status: status,
      available_seats: available_seats,
      department_id: department.id
    )
    puts "Add course: #{number} (#{title})"
  end
  puts "Totally added #{Course.all.size} courses"
end