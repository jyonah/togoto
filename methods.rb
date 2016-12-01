require 'sqlite3'

# INTERFACE METHODS
#NEW USER BRANCH
def welcome_new_user
  puts "Welcome to togoto!"
  puts "Let's build your togoto lists!"
  puts ""
end

def ask_users_name
  puts "To start with, what's your full name?"
  current_user = [gets.chomp]
  people = make_names(current_user)
  puts ""
  puts "Nice to meet you #{people[0][:first_name]}!"
  puts ""
  people
end

def build_friends
  puts ""
  puts "Great! Now we'll build your list of friends."
  puts "List friend names, sperated by a comma and a space."
  friends_names = gets.chomp.split(', ')
  friends = make_names(friends_names)
end

def build_venues
  puts "Now, let's build your venues list!"
  puts "List venues you've been to and like to recommend seperated by a comma and a space."
  venues = []
  venues = make_venues(venues, true)
  puts ""
  puts "Now list any venues you have been meaning to try or have had recommended seperated by a comma and a space."
  venues = make_venues(venues, false)
end #build_venues

def build_join(people_arr, venues_arr, db)
  puts ""
  puts "Alright, let's record who has been where."
  puts "We'll start with #{people_arr[1][1]}"
  people_arr.each do |person|
    if person[0] > 1
      venues_arr.each do |venue|
        valid_response = nil
        until valid_response
          valid_response = false
          puts "Has #{person[1]} been to #{venue[1]}? (y/n)"
          response = gets.chomp
          attended = yn_to_boolean(response)
          if response != nil
            valid_response = true
          end
        end #until valid_response
        db.save_to_join_table(person[0], venue[0], attended)
      end #venues_arr.each do |venues_idx|
    end #if index > 0
  end #people_arr.each do |index|
end #build_join

#RETURNING USER BRANCH
def welcome_returning_user(current_user)
  puts "Welcome back, #{current_user}."
end

#SHARED
def display_togoto_list

end

def yn_to_boolean(response)
  if response == "y"
    true
  elsif response == "n"
    false
  else
    nil
  end
end

#DATASET METHODS
def make_names(names_array)
  names_arr = []
  names_array.each do |fullname|
    names = fullname.split(' ')
    this_person = {}
    this_person[:first_name] = names.shift
    this_person[:middle_name] = nil
    this_person[:last_name] = names.delete_at(-1)
    if names.length > 0
      this_person[:middle_name] = names.join(' ')
    end #if
    names_arr << this_person
  end #do
  names_arr
end #method

def make_venues(venues_arr, boolean)
  venue_names = gets.chomp.split(', ')
  if venues_arr.length == 0
    venue_id = 1
  else
    venue_id = venues_arr[-1][:venue_id] + 1
  end
  venue_names.each do |venue|
    venues_arr << {venue_id: venue_id, name: venue, user_attended: boolean}
    venue_id += 1
  end #venue_names.each do
  venues_arr
end #make_venues

# DATABASE METHODS
class SQLDatabase

  def initialize
    @db = SQLite3::Database.new("togoto.db")
  end

  def no_tables?
    tables = []
    @db.execute(LIST_TABLES) do |row|
      tables << row
    end #@db.execute(list_tables) do |row|

    if tables.length > 0
      false
    else
      true
    end #if tables.length > 0
  end #no_tables?

  def fetch_people
    @db.execute('SELECT * FROM people')
  end

  def fetch_venues
    @db.execute('SELECT * FROM venues')
  end

  def fetch_user
    user_arr = @db.execute('SELECT first_name FROM people WHERE person_id=1')
    user_arr[0][0]
  end

  def save_venues_table(venues_arr)
    @db.execute(CREATE_VENUES)
    venues_arr.each do |row|
      @db.execute('INSERT INTO venues (name) VALUES (?)', row[:name])
    end #venues_arr.each do |row|
  end #save_venues_table(venues_arr)

  def save_people_table(people_arr)
    @db.execute(CREATE_PEOPLE)
    people_arr.each do |row|
      @db.execute('INSERT INTO people (first_name, middle_name, last_name) VALUES (?, ?, ?)', row[:first_name], row[:middle_name], row[:last_name])
    end #venues_arr.each do |row|
  end #save_venues_table(venues_arr)

  def create_join_table
    @db.execute(CREATE_JOIN)
  end

  def save_user_join_values(venues_arr)
    venues_arr.each do |this_venue|
      @db.execute('INSERT INTO join_table (person_id, venue_id, attended) VALUES (?, ?, ?)', 1, this_venue[:venue_id], this_venue[:user_attended].to_s)
    end
  end

  # ERROR:
  # /Users/Jonah/.rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.12/lib/sqlite3/statement.rb:41:in `bind_param': can't prepare TrueClass (RuntimeError)
	# from /Users/Jonah/.rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.12/lib/sqlite3/statement.rb:41:in `block in bind_params'
	# from /Users/Jonah/.rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.12/lib/sqlite3/statement.rb:37:in `each'
	# from /Users/Jonah/.rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.12/lib/sqlite3/statement.rb:37:in `bind_params'
	# from /Users/Jonah/.rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.12/lib/sqlite3/database.rb:138:in `block in execute'
	# from /Users/Jonah/.rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.12/lib/sqlite3/database.rb:95:in `prepare'
	# from /Users/Jonah/.rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.12/lib/sqlite3/database.rb:137:in `execute'
	# from /Users/Jonah/DevBootcamp/projects/togoto/methods.rb:165:in `block in save_user_join_values'
	# from /Users/Jonah/DevBootcamp/projects/togoto/methods.rb:164:in `each'
	# from /Users/Jonah/DevBootcamp/projects/togoto/methods.rb:164:in `save_user_join_values'
	# from interface.rb:18:in `<main>'

  def save_to_join_table(person_id, venue_id, attended)
    @db.execute('INSERT INTO join_table (person_id, venue_id, attended) VALUES (?, ?, ?)', person_id, venue_id, attended.to_s)
  end

end #class
# SQL Variables
LIST_TABLES = <<-SQL
  SELECT * FROM sqlite_master WHERE type='table';
SQL

CREATE_PEOPLE = <<-SQL
  CREATE TABLE IF NOT EXISTS people (
    person_id INTEGER PRIMARY KEY,
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    last_name VARCHAR(255)
  );
SQL

CREATE_VENUES = <<-SQL
  CREATE TABLE IF NOT EXISTS venues (
    venue_id INTEGER PRIMARY KEY,
    name VARCHAR(255)
  );
SQL

CREATE_JOIN = <<-SQL
  CREATE TABLE IF NOT EXISTS join_table (
    id INTEGER PRIMARY KEY,
    person_id INT,
    venue_id INT,
    attended BOOLEAN,
    FOREIGN KEY (person_id) REFERENCES people(person_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
  );
SQL
