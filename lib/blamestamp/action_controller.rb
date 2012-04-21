require 'action_controller'

module Blamestamp
  module Blamer
    extend ActiveSupport::Concern

    included do
      self.before_filter :set_blamer
      self.after_filter :unset_blamer
    end

    def set_blamer
      if user_signed_in?
        Thread.current[:blamer_id] = current_user.id
      end
    end

    def unset_blamer
      Thread.current[:blamer_id] = nil
    end
  end
end

ActionController::Base.send :include, Blamestamp::Blamer
