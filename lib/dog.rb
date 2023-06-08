require 'pry'
class Dog

#  attr_reader :name, :breed, :id
 attr_accessor :id, :name, :breed

  def initialize(name:, breed:, id: nil)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table

    sql = <<-SQL
     CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY,breed TEXT,name TEXT)
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table

    sql = <<-SQL
     DROP TABLE IF EXISTS dogs
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
     INSERT INTO dogs(name, breed)VALUES(?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    setup_id
  end

  def setup_id
    query = <<-SQL
        SELECT last_insert_rowid() FROM dogs
    SQL
    self.id = DB[:conn].execute(query)[0][0]
  end

  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
    dog
  end

  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM dogs
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.find(num)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, num).map do |row|
      self.new_from_db(row)
    end.first
  end

end


# binding.pry
