require 'mechanize'
require "pry"

start_time = Time.now
# Schedule Plus URL
url = 'http://www.cerritos.edu/schedule/'

agent = Mechanize.new
page = agent.get(url)

form = page.form('Index')
status_checkboxes = form.checkboxes_with('Types')

# Check all boxes
status_checkboxes.each do |checkbox|
  checkbox.check
end

total_classes = 0

puts "Start Fetching..."

# Refresh departments on the index page
form.action = 'index.cgi'
rpage = form.submit

# Fetch out all departments under the status
abbrs = rpage.search('.index .index .index label')
names = rpage.search('.index-desc label')
abbrs.each_with_index do |abbr, index|
  puts "#{index}: #{abbr.text.strip}\t#{names[index].text.strip}"
end

# Select all departments
rform = rpage.form
rform.checkboxes_with('Depts').each do |department|
  department.check
end

# Go to the next page
npage = agent.submit(rform, rform.button)

# Select all courses
nform = npage.form
abbr_list = []
number_list = []
title_list = []
npage.search('.course-desc label').each do |title|
  title_list << title.text.strip
end
nform.checkboxes_with('Courses').each do |course|
  course.check
  abbr, number = course.value.partition(/\d\S*/)
  abbr_list << abbr
  number_list << number
  if abbr.match(/\d+/) || number.empty?
    raise "#{course.value}"
  end
end
result_page = agent.submit(nform, nform.button)
tables = result_page.search('table')
tables.each_with_index do |table, index|
  table.css('tr').each do |row|
    next if row.at_css('td.sess1nbr2').nil?
    code = row.at_css('td.sess1nbr2').text[/\d{5}/]
    next if code.nil?
    begin
      seats = row.css("td[title='Available Seats']").text.strip.to_i
    rescue
      raise seats
    end
    status = row.css('td')[7].text.strip
    instructor = row.css('td')[8].text.strip
    puts "#{status} #{abbr_list[index]} #{number_list[index]}\t#{code}\t#{seats}\t#{instructor}"
    total_classes += 1
  end
end

elapsed_time = Time.now - start_time
puts "Totally fetch #{total_classes} classes in #{elapsed_time} seconds"
