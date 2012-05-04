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
        Blamestamp::set_blame_user(current_user.id)
      end
    end

    def unset_blamer
      Blamestamp::unset_blame_user()
    end
  end
end

ActionController::Base.send :include, Blamestamp::Blamer
