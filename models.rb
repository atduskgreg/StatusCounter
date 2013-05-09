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

  def simple_json
    json_hash = {
      :name => name,
      :id => self.id,
      :count_options => count_options.collect{|c| {:name => c.name, :id => c.id} } 
    }
    json_hash.to_json
  end

  def graph_json
    json_hash = {:graph => {
                  :title => name,
                  :refreshEveryNSeconds => 10,
                  :datasequences => []
                  }
                }
    count_options.each do |opt|
      datasequence = {:title => opt.name, :datapoints => []}
      opt.ticks.each do |tick|
        datasequence[:datapoints] << {:title => tick.created_at.to_s, :value => opt.ticks_at(tick.created_at)}
      end
      json_hash[:graph][:datasequences] << datasequence
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

  def ticks_at date_time
    self.ticks.count(:created_at.lte => date_time)
  end
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
