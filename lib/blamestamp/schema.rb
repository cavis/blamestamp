module Blamestamp
  module Schema
    extend ActiveSupport::Concern

    def blamestamps
      column(:blame_cre_at, :datetime)
      column(:blame_upd_at, :datetime)
      column(:blame_cre_by, :integer)
      column(:blame_upd_by, :integer)
    end

    def drop_blamestamps(tbl_name)
      remove_column tbl_name, :blame_cre_at
      remove_column tbl_name, :blame_upd_at
      remove_column tbl_name, :blame_cre_by
      remove_column tbl_name, :blame_upd_by
    end
  end
end

# include 3 times, so all variations migrations work
ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Blamestamp::Schema)
ActiveRecord::ConnectionAdapters::Table.send(:include, Blamestamp::Schema)
ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Blamestamp::Schema)
