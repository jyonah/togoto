require 'sqlite3'

# SQL Variables
LIST_TABLES = <<-SQL
  SELECT * FROM sqlite_master WHERE type='table';
SQL

CREATE_PEOPLE = <<-SQL
  CREATE TABLE people IF NOT EXISTS (
    person_id INTEGER PRIMARY KEY,
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    last_name VARCHAR(255)
  );
SQL

CREATE_VENUES = <<-SQL
  CREATE TABLE venues IF NOT EXISTS (
    venue_id INTEGER PRIMARY KEY,
    name VARCHAR(255)
  );
SQL

CREATE_JOIN = <<-SQL
  CREATE TABLE join IF NOT EXISTS (
    id INTEGER PRIMARY KEY,
    person_id INT,
    venue_id INT,
    FOREIGN KEY (person_id) REFERENCES people(person_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
  );
SQL

  # DATABASE METHODS

class SQLDatabase

  def initialize
    @db = SQLite3::Database.new("experiments.db")
  end

  def tables_exist?
    tables = []
    @db.execute(LIST_TABLES) do |row|
      tables << row
    end #@db.execute(list_tables) do |row|

    if tables.length > 0
      true
    else
      false
    end #if tables.length > 0
  end #tables_exist

  def save_venues_table(venues_arr)
    @db.execute(CREATE_VENUES)
    venues_arr.each do |row|
      @db.execute('INSERT INTO venues (name) VALUES (?)', row[:name])
    end #venues_arr.each do |row|
  end #self.save_venues_table(venues_arr)

  def save_people_table(people_arr)
    @db.execute(CREATE_PEOPLE)
    people_arr.each do |row|
      @db.execute('INSERT INTO people (first_name, middle_name, last_name) VALUES (?, ?, ?)', row[:first_name], row[:middle_name], row[:last_name])
    end #venues_arr.each do |row|
  end #self.save_venues_table(venues_arr)

end #module
