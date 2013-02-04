desc "Fetch courses"
task :fetch_courses => :environment do
  require 'mechanize'
  # Set nbsp constant
  NBSP = Nokogiri::HTML("&nbsp;").text

  start_time = Time.now
  # Schedule Plus URL
  url = 'http://www.cerritos.edu/schedule/'

  agent = Mechanize.new
  page = agent.get(url)

  form = page.form('Index')

  # Fetch the term information
  puts "Fetching the term information"
  term_code = form.checkbox('Terms').value
  term_year, term_season = page.search('.terms label').text.split
  fields = {
    code:   term_code,
    year:   term_year.to_i,
    season: term_season.downcase
  }
  term = Term.find(:first, conditions: fields) || Term.create!(fields)

  status_checkboxes = form.checkboxes_with('Types')
  # Check all boxes
  status_checkboxes.each do |checkbox|
    checkbox.check
  end

  total_classes = 0

  # Refresh departments on the index page
  form.action = 'index.cgi'
  rpage = form.submit

  # Fetch out all departments
  abbrs = rpage.search('.index .index .index label')
  names = rpage.search('.index-desc label')
  puts "Fetch all departments"
  abbrs.each_with_index do |abbr, index|
    fields = {
      abbr: abbr.text.strip.downcase,
      name: names[index].text.strip.downcase
    }
    next if Department.find(:first, conditions: fields)
    Department.create!(fields)
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

  # Fetch all titles
  npage.search('.course-desc label').each do |title|
    title_list << title.text.strip
  end

  # Fetch all numbers with proper abbr
  nform.checkboxes_with('Courses').each do |course|
    course.check
    abbr, number = course.value.partition(/\d\S*/)
    abbr_list << abbr.downcase
    number_list << number
    if abbr.match(/\d+/) || number.empty?
      raise "#{course.value}"
    end
  end

  puts "Fetch all courses"
  result_page = agent.submit(nform, nform.button)
  tables = result_page.search('table')
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
        department_id: Department.where('abbr = ?', abbr_list[index]).first.id,
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
          total_classes += 1
        else
          course.attributes = fields
          if course.changed?
            course.save!
            total_classes += 1
          end
        end
      rescue Exception => e
        puts e
        pp fields
      end
    end
  end

  elapsed_time = Time.now - start_time
  puts "Totally fetch #{total_classes} classes in #{elapsed_time} seconds"
end
