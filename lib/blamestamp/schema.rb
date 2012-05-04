module Blamestamp
  module Schema
    extend ActiveSupport::Concern

    def blamestamps(options = {})
      flds = options_to_fields(options)
      column(flds[0], :datetime)
      column(flds[1], :datetime)
      column(flds[2], :integer)
      column(flds[3], :integer)
    end

    def drop_blamestamps(tbl_name, options = {})
      flds = options_to_fields(options)
      remove_column tbl_name, :blame_cre_at
      remove_column tbl_name, :blame_upd_at
      remove_column tbl_name, :blame_cre_by
      remove_column tbl_name, :blame_upd_by
    end

    private

    def options_to_fields(opts)
      prefix     = opts[:prefix] || 'blame'
      cre_at_fld = opts[:cre_at] || "#{prefix}_cre_at"
      upd_at_fld = opts[:upd_at] || "#{prefix}_upd_at"
      cre_by_fld = opts[:cre_by] || "#{prefix}_cre_by"
      upd_by_fld = opts[:upd_by] || "#{prefix}_upd_by"
      return [cre_at_fld, upd_at_fld, cre_by_fld, upd_by_fld]
    end
  end
end

# include 3 times, so all variations migrations work
ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Blamestamp::Schema)
ActiveRecord::ConnectionAdapters::Table.send(:include, Blamestamp::Schema)
ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Blamestamp::Schema)
