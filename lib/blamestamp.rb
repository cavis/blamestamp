module Blamestamp
end

# activerecord "blameable"
if defined?(ActiveRecord)
  require 'blamestamp/active_record'
else
  raise "blamestamp only works with active_record"
end

# actioncontroller "blamer"
if defined?(ActionController)
  require 'blamestamp/action_controller'
else
  raise "blamestamp only works with action_controller"
end
