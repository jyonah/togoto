require_relative 'db_methods'
require_relative 'dataset_methods'

module Interface

  def self.new_user
    puts "Welcome to togoto!"
    puts "Let's build your togoto lists!"
    puts ""
    puts "To start with, what's your full name?"
    current_user = [gets.chomp]
    people = Dataset.make_names(current_user)
    puts ""
    puts "Nice to meet you #{people[0][:first_name]}!"
    puts "Now, let's build your venues list!"
    venues = build_venues
    puts ""
    puts "Great! Now we'll build your list of friends."
    friends = build_friends
    people.concat(friends)
    database.save_venues_table(venues)
    database.save_people_table(people)
  end

  def self.build_friends
    puts "List friend names, sperated by a comma and a space."
    friends_names = gets.chomp.split(', ')
    friends = Dataset.make_names(friends_names)
    friends
  end

  def self.build_venues
    puts "List venues you've been to and like to recommend seperated by a comma and a space."
    venue_names = gets.chomp.split(', ')
    venues = []
    venue_names.each do |venue|
      venues << {name: venue, user_attended: true}
    end #venue_names.each do
    puts ""
    puts "Now list any venues you have been meaning to try or have had recommended seperated by a comma and a space."
    venue_names = gets.chomp.split(', ')
    venue_names.each do |venue|
      venues << {name: venue, user_attended: false}
    end #venue_names.each do
    venues
  end #self.build_venues

end #module
