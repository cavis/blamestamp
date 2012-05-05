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
        self.after_destroy :blame_destroy
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

    # main blamer workhorse
    def blame_them!(at_key, by_key, force=false)
      at_col = self.blameable_config[at_key]
      by_col = self.blameable_config[by_key]

      # only blame if it wasn't explicitly set
      if force || !(self.changed - [at_col.to_s, by_col.to_s]).empty?
        self[at_col] = Time.now
        self[by_col] = Blamestamp::get_blame_user
        return true
      end

      return false # nothing saved!
    end

    # cascade the blame up
    def cascade_blame
      self.blameable_config[:cascade].each do |assoc|
        if self.send(assoc)
          self.send(assoc).blame_them!(:upd_at, :upd_by, true)
          self.send(assoc).save :validate => false
        end
      end
    end

    # create callback
    def blame_create
      self.cascade_blame() if self.blame_them!(:cre_at, :cre_by)
    end

    # update callback
    def blame_update
      self.cascade_blame() if self.blame_them!(:upd_at, :upd_by)
    end

    # destory callback
    def blame_destroy
      self.cascade_blame()
    end
  end
end

ActiveRecord::Base.send :include, Blamestamp::Blameable
