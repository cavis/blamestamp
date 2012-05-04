module Blamestamp
  def self.set_blame_user(id)
    Thread.current[:blamer_id] = id
  end
  def self.get_blame_user
    return Thread.current[:blamer_id]
  end
  def self.unset_blame_user
    Thread.current[:blamer_id] = nil
  end
end

# activerecord "blameable"
if defined?(ActiveRecord)
  require 'blamestamp/active_record'
  require 'blamestamp/schema'
else
  raise "blamestamp only works with active_record"
end

# actioncontroller "blamer"
if defined?(ActionController)
  require 'blamestamp/action_controller'
else
  raise "blamestamp only works with action_controller"
end
