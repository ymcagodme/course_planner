# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'

admin = User.new(:name => ENV['ADMIN_NAME'].dup,
                :email => ENV['ADMIN_EMAIL'].dup,
                :password => ENV['ADMIN_PASSWORD'].dup, 
                :password_confirmation => ENV['ADMIN_PASSWORD'].dup)
puts 'admin: ' << admin.name
admin.add_role :admin
admin.skip_confirmation!
admin.save!

user = User.new(:name => 'Second User',
                :email => 'user@example.com',
                :password => 'foobar',
                :password_confirmation => 'foobar')
puts 'user: ' << user.name
user.add_role :VIP
user.skip_confirmation!
user.save!

active_admin = AdminUser.new(:email => ENV['ADMIN_EMAIL'].dup,
                             :password => ENV['ADMIN_PASSWORD'].dup,
                             :password_confirmation => ENV['ADMIN_PASSWORD'].dup)
