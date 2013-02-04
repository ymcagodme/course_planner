desc "Fetch courses"
task :fetch_courses => :environment do
  require 'mechanize'
  puts "Start the fetching process\n"

  # Set nbsp constant
  NBSP = Nokogiri::HTML("&nbsp;").text

  url = 'http://www.cerritos.edu/schedule/' # Cerritos College schedule
  start_time = Time.now

  agent = Mechanize.new
  print "Start connenting..."
  page = agent.get(url)
  print "done\n"

  # Fetch the term information
  print "Fetching term information..."
  term = extract_term(page)
  print "done\n"

  # Check all status boxes
  form = page.form('Index')
  form = check_all_checkboxes(form, 'Types')

  # Refresh departments on the index page to get available departments
  print "Fetching departments..."
  form.action = 'index.cgi'
  rpage = form.submit
  print "done\n"

  # Fetch out all departments
  extract_departments(rpage)

  # Select all departments
  rform = rpage.form
  rform = check_all_checkboxes(rform, 'Depts')

  # Submit
  npage = agent.submit(rform, rform.button)

  department_list = [] # abbr: CIS, name: Computer and Information Sciences
  number_list     = [] # CIS "182" <-- 180 is the number
  title_list      = [] # Class title: Java Programming

  # Select all courses
  nform = npage.form
  nform = check_all_checkboxes(nform, 'Courses')

  # Cache all numbers with departments
  nform.checkboxes_with('Courses').each do |course|
    abbr, number = course.value.partition(/\d\S*/)
    department_list << abbr.downcase
    number_list << number
    #FIXME: should have the error logging
    if abbr.match(/\d+/) || number.empty?
      raise "#{course.value}"
    end
  end

  # Cache all titles
  npage.search('.course-desc label').each do |title|
    title_list << title.text.strip
  end

  # Fetch all courses
  print "Fetching courses..."
  result_page = agent.submit(nform, nform.button)
  print "done\n"
  extract_courses(result_page, department_list, number_list, title_list, term)

  elapsed_time = Time.now - start_time
  puts "All fetching completed in #{elapsed_time} seconds"
end

def extract_term(page)
  form = page.form('Index')
  term_code = form.checkbox('Terms').value
  term_year, term_season = page.search('.terms label').text.split
  fields = {
    code:   term_code,
    year:   term_year.to_i,
    season: term_season.downcase
  }
  term = Term.find(:first, conditions: fields) || Term.create!(fields)
end

def extract_departments(page)
  abbrs = page.search('.index .index .index label')
  names = page.search('.index-desc label')
  abbrs.each_with_index do |abbr, index|
    fields = {
      abbr: abbr.text.strip.downcase,
      name: names[index].text.strip.downcase
    }
    next if Department.find(:first, conditions: fields)
    Department.create!(fields)
  end
end

def extract_courses(page, department_list, number_list, title_list, term)
  created_courses = 0
  updated_courses = 0
  tables = page.search('table')
  tables.each_with_index do |table, index|
    table.css('tr').each do |row|
      next if row.at_css('td.sess1nbr2').nil?
      code = row.at_css('td.sess1nbr2').text[/\d{5}/]
      next if code.nil?
      seats = row.css("td[title='Available Seats']").text.strip.to_i
      status = row.css('td')[7].text.strip.downcase.gsub(NBSP, " ")
      instructor = row.css('td')[8].text.strip
      fields = {
        term_id: term.id,
        department_id: Department.where('abbr = ?', department_list[index]).first.id,
        number: number_list[index],
        code: code,
        status: status,
        title: title_list[index],
        available_seats: seats,
        instructor: instructor
      }

      begin
        course = Course.where('code = ?', code).first
        if course.nil?
          Course.create!(fields)
          puts ""
          puts "Created a new course"
          puts fields
          puts "==================================="
          created_courses += 1
        else
          course.attributes = fields
          if course.changed?
            puts ""
            puts "#{course.department.name} #{course.number}(#{course.code}) has changed:"
            puts "==================================="
            puts course.changes
            course.save!
            updated_courses += 1
          end
        end
      rescue Exception => e
        puts e
        pp fields
      end
    end
  end
  puts "\n======== Result ========"
  puts "Totally created #{created_courses} courses"
  puts "Totally updated #{updated_courses} courses"
  puts "========================\n"
end

def check_all_checkboxes(form, name)
  status_checkboxes = form.checkboxes_with(name)
  status_checkboxes.each do |checkbox|
    checkbox.check
  end
  form
end
