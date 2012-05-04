require 'active_record'

module Blamestamp
  module Blameable
    extend ActiveSupport::Concern

    module ClassMethods
      def blameable(options = {})
        c = options_to_config(options)
        class_attribute :blameable_config
        self.blameable_config = c

        # associations
        self.belongs_to c[:cre_user], :class_name => c[:class], :foreign_key => c[:cre_by]
        self.belongs_to c[:upd_user], :class_name => c[:class], :foreign_key => c[:upd_by]

        # callbacks
        self.before_create :blame_create
        self.before_update :blame_update
        self.after_destroy :blame_delete
      end

      private

      def options_to_config(opts)
        prefix = opts[:prefix] || "blame"
        cfg = {
          :cre_at   => opts[:cre_at]   || "#{prefix}_cre_at".to_sym,
          :upd_at   => opts[:upd_at]   || "#{prefix}_upd_at".to_sym,
          :cre_by   => opts[:cre_by]   || "#{prefix}_cre_by".to_sym,
          :upd_by   => opts[:upd_by]   || "#{prefix}_upd_by".to_sym,
          :cre_user => opts[:cre_user] || "#{prefix}_cre_user".to_sym,
          :upd_user => opts[:upd_user] || "#{prefix}_upd_user".to_sym,
          :class    => opts[:class]    || "User".to_sym,
          :cascade  => opts[:cascade]  || [],
        }
        cfg[:cascade] = [cfg[:cascade]] if !cfg[:cascade].kind_of?(Array)
        return cfg
      end
    end

    # create callback
    def blame_create
      self[self.blameable_config[:cre_at]] = Time.now
      self[self.blameable_config[:cre_by]] = Blamestamp::get_blame_user()
      self.blameable_config[:cascade].each { |assoc| self.send(assoc).blame_update() if self.send(assoc) }
    end

    # update callback
    def blame_update
      self[self.blameable_config[:upd_at]] = Time.now
      self[self.blameable_config[:upd_by]] = Blamestamp::get_blame_user()
      self.blameable_config[:cascade].each { |assoc| self.send(assoc).blame_update() if self.send(assoc) }
    end

    # delete callback (just updates cascades)
    def blame_delete
      self.blameable_config[:cascade].each { |assoc| self.send(assoc).blame_update() if self.send(assoc) }
    end
  end
end

ActiveRecord::Base.send :include, Blamestamp::Blameable
