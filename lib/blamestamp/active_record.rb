require 'active_record'

module Blamestamp
  module Blameable
    extend ActiveSupport::Concern

    module ClassMethods
      def blameable(options = {})
        self.before_create :blame_create
        self.before_update :blame_update
      end
    end

    def blame_create
      self.blame_cre_at = Time.now
      self.blame_cre_by = Thread.current[:blamer_id]
    end

    def blame_update
      self.blame_upd_at = Time.now
      self.blame_upd_by = Thread.current[:blamer_id]
    end
  end
end

ActiveRecord::Base.send :include, Blamestamp::Blameable
