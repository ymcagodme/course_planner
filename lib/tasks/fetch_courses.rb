require 'mechanize'

# Schedule Plus URL
url = 'http://www.cerritos.edu/schedule/'

agent = Mechanize.new
page = agent.get(url)

form = page.form('Index')
status_checkboxes = form.checkboxes_with('Types')

# Uncheck all boxes
status_checkboxes.each do |checkbox|
  checkbox.uncheck
end

total_classes = 0

puts "Start Fetching..."
# Fetch starting from each status
status_checkboxes.each do |status|
  status.check

  # Refresh departments on the index page
  form.action = 'index.cgi'
  rpage = form.submit

  # Fetch out all departments under the status
  departments = rpage.search('.index-desc label')

  # Select all departments
  rform = rpage.form
  rform.checkboxes_with('Depts').each do |department|
    department.check
  end

  # Go to the next page
  npage = agent.submit(rform, rform.button)

  # Fetch all courses under the status
  courses = npage.search('label:nth-child(2)')
  # courses.each do |course|
  #   puts "#{course.text}"
  # end

  # Select all courses
  nform = npage.form
  nform.checkboxes_with('Courses').each do |course|
    course.check
  end

  # Go to the next page
  result_page = agent.submit(nform, nform.button)
  number_list = []
  numbers = result_page.search('.sess1 , .sess1nbr2')
  numbers.each do |num|
    result = num.text[/[0-9\.]+/]
    number_list << result if result
  end

  puts "====================\n"
  puts "Fetch #{number_list.size} results"
  puts "====================\n"
  total_classes += number_list.size

  status.uncheck
end

puts "Totally fetch #{total_classes} classes"