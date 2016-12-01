#SETUP SQL
require 'sqlite3'
db = SQLite3::Database.new("experiments.db")
create_friends_table = <<-SQL
  CREATE TABLE IF NOT EXISTS friends(
    id INTEGER PRIMARY KEY,
    name VARCHAR(255)
  )
SQL

there_are_tables = <<-SQL
  SELECT * FROM sqlite_master WHERE type='table';
SQL

p "Checking if there are tables..."
puts ""
tables = []
db.execute(there_are_tables) do |row|
  tables << row
end

if tables.length > 0
  p "There are tables."
else
  p "There are no tables."
end

puts ""
p "Creating Table..."
db.execute(create_friends_table)
puts ""

p "Checking if there are tables..."
puts ""
tables = []
db.execute(there_are_tables) do |row|
  tables << row
end

if tables.length > 0
  p "There are tables."
else
  p "There are no tables."
end
