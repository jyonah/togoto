require_relative 'methods/interface_methods'
require_relative 'methods/dataset_methods'
require 'sqlite3'

puts "List friend names."
friends_names = gets.chomp.split(', ')
friends = Dataset.make_names(friends_names)
puts "Friends Built:"
p friends
