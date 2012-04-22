Blamestamp
=========

Blamestamp is intended as an easy way to record the creating and latest-editing user for an Active Record.  It works similarly to the built-in Active Record timestamps module, but in a more configurable and predictable manner.  Column names are configurable, as are default values, in case you allow non logged-in users to edit some things.  Additionally, it allows configuration of when editing a record will update the blamestamps on a related record.


Requirements
------------

### Ruby and Rails

Requires Ruby version **>= 1.9.2** and Rails version **>= 3.0**

### Current version limitations

Currently only works with a combination of Devise, ActiveRecord and ActiveController.


Installation
------------

Blamestamp should be installed as a gem in your app.  Currently, it is only available as the latest-build on github.  Fixed versions forth-coming.

Include the gem in your Gemfile:

    gem "blamestamp", :git => "https://github.com/cavis/blamestamp"


Getting Started
---------------

### In your migrations:

    class CreateFoos < ActiveRecord::Migration
      def change
        create_table :foos do |t|
          t.string :bar
          t.blamestamps
        end
      end
    end

Or, if modifying an existing model:

    class AddBlamestampsToFoos < ActiveRecord::Migration
      def up
        change_table :foos do |t|
          t.blamestamps
        end
      end
      def down
        drop_blamestamps :foos
      end
    end


### In your model:

    class Foo < ActiveRecord::Base
      blameable
    end


Usage
-----

By default, blamestamps adds 4 columns to your models:

* `blame_cre_at`
* `blame_upd_at`
* `blame_cre_by`
* `blame_upd_by`

When a record is created, `blame_cre_at` and `blame_cre_by` will be set.  If no remote-user is logged in (via a controller), `blame_cre_by` will be nil.  On initial creation, both `blame_upd_at` and `blame_upd_by` will be nil.

When a record is updated for the first time (and every time after), `blame_upd_at` and `blame_upd_by` are modified.  Again, `blame_upd_by` will remain nil if there is no remote-user.


Issues and Contributing
-----------------------

Please, let me know about any bugs/feature-requests via the issues tracker.  And if you'd like to contribute, send me a note!  Thanks.


License
-------

Blamestamp is free software, and may be redistributed under the MIT-LICENSE.
