#SETUP SQL
require 'sqlite3'
db = SQLite3::Database.new("experiments.db")

venues = [
  {:name=>"Shizen", :user_attended=>true},
  {:name=>"Goku", :user_attended=>true},
  {:name=>"Millenium", :user_attended=>false},
  {:name=>"Cinnaholic", :user_attended=>false}
]

CREATE_TABLE_CMD = <<-SQL
  CREATE TABLE IF NOT EXISTS (
    ? INTEGER PRIMARY KEY,
    ? VARCHAR(255),
    ? BOOLEAN
  )
SQL

# db.execute(create_table_cmd, [])
db.execute("create table ? if not exists(? integer primary key,? varchar(255),? boolean);",
                "venues",
                "venue_id",
                "name",
                "user_attended")


# def save_table(table_arr, table_name, singular_name, db)
#   placeholders = [table_name, "#{singular_name}_id"]
#   table_arr[0].each_key do |key|
#     placeholders << key.to_s
#   end
# end

# p save_table(venues, "venues", "venue", db)
