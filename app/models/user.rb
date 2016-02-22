require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'bcrypt'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/todoApp.db")
class Task
  include DataMapper::Resource
  property :id, Serial
  property :todo, Text, required: true
  property :priority, Integer, required: false
  property :done, Boolean, required: true, default: false
  property :created, DateTime

  belongs_to :user
end

class User
  include DataMapper::Resource
  include BCrypt
  property :id, Serial
  property :firstname, Text, required: true
  property :lastname, Text, required: true
  property :email, Text, required: true, unique: true
  property :password, Text, required: true
  property :created, DateTime
  property :salt, Text

  has n, :tasks
end

DataMapper.finalize.auto_upgrade!
