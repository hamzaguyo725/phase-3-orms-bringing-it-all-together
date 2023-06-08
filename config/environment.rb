require 'bundler'
Bundler.require

require_relative '../lib/dog'

DB = { conn: SQLite3::Database.new("db/dogs.db") }

Dog.create_table

dog1 =Dog.new(name: "Joe", breed: "Corgi")

puts dog1

pp dog1.name