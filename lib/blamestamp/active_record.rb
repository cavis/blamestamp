require 'active_record'

module Blamestamp
  class NoBlameUserError < StandardError
  end
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
          :required => opts[:required] || false,
        }
        cfg[:cascade] = [cfg[:cascade]] if !cfg[:cascade].kind_of?(Array)
        return cfg
      end
    end

    # cascade the blame up
    def cascade_blame!(time, usr_id)
      self.blameable_config[:cascade].each do |assoc|
        if self.send(assoc)
          self.send(assoc).blame_cascade(time, usr_id)
          self.send(assoc).save :validate => false
        end
      end
    end

    # create callback
    def blame_create
      at_col = self.blameable_config[:cre_at]
      by_col = self.blameable_config[:cre_by]
      name   = self.blameable_config[:cre_user]

      # only set blanks
      self[at_col] = Time.now if self[at_col].blank?
      self[by_col] = Blamestamp::get_blame_user if self[by_col].blank? && !self.send(name)

      # required option
      raise NoBlameUserError if self.blameable_config[:required] && !self[by_col]

      # cascade
      self.cascade_blame!(self[at_col], self[by_col])
    end

    # update callback
    def blame_update
      at_col = self.blameable_config[:upd_at]
      by_col = self.blameable_config[:upd_by]
      name   = self.blameable_config[:upd_user]

      # respect manual user updates
      self[at_col] = Time.now unless self.changed.include?(at_col)
      self[by_col] = Blamestamp::get_blame_user unless self.changed.include?(by_col)
      self.cascade_blame!(self[at_col], self[by_col])
    end

    # destory callback
    def blame_destroy
      self.cascade_blame!(Time.now, Blamestamp::get_blame_user)
    end

    # called by other models, when they're updated
    def blame_cascade(time, usr_id)
      at_col = self.blameable_config[:upd_at]
      by_col = self.blameable_config[:upd_by]
      self[at_col] = time
      self[by_col] = usr_id
    end

    # check if non-blame columns have changed
    def has_non_blame_changes?
      cols = [
        self.blameable_config[:cre_at],
        self.blameable_config[:cre_by],
        self.blameable_config[:upd_at],
        self.blameable_config[:upd_by],
      ]
      (self.changed - cols).empty? ? false : true
    end
  end
end

ActiveRecord::Base.send :include, Blamestamp::Blameable
