require 'rubygems'
require 'bundler/setup'
require 'dm-aggregates'
require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'open-uri'
require 'dm-timestamps'
require 'date'
require 'json'

DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_SILVER_URL'] || 'postgres://localhost/status_counter')

class Counted
  include DataMapper::Resource

  property :id, Serial
  property :name, Text

  has n, :count_options

  def to_json
    json_hash = {:graph => {
                  :title => name,
                  :refreshEveryNSeconds => 10,
                  :datapoints => []
                  }
                }
    count_options.each do |opt|
      json_hash[:datapoints] << {opt.name => opt.ticks.count}
    end

    json_hash.to_json
  end
end

class CountOption
  include DataMapper::Resource

  property :id, Serial
  property :name, Text

  belongs_to :counted
  has n, :ticks
end

class Tick
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime

  belongs_to :count_option
end

class User
  include DataMapper::Resource
  property :id, Serial

  property :username, String
  property :password, String
end



DataMapper.finalize
