require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/todoApp.db")
class Task
  include DataMapper::Resource
  property :id, Serial
  property :task, Text, :required => true
  property :done, Boolean, :required => true, :default => false
  property :created, DateTime
  property :updated, DateTime

  belongs_to :user


end


class User
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true
  property :password, Text, :required => true
  property :created, DateTime

  has n, :tasks


end

DataMapper.finalize.auto_migrate!
