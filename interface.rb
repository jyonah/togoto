require_relative 'methods'
require 'sqlite3'
db = SQLDatabase.new

# if db.no_tables?
  welcome_new_user
  people = ask_users_name

  venues = build_venues
  friends = build_friends
  people.concat(friends)

  db.save_venues_table(venues)
  db.save_people_table(people)
  db.create_join_table

  db.save_user_join_values(venues)

  people = db.fetch_people
  venues = db.fetch_venues

  build_join(people, venues, db)

# else
#   current_user = db.fetch_user
#   welcome_returning_user(current_user)
#   display_togoto_list
# end
