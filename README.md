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

Blamestamp should be installed as a gem in your app.

Include the gem in your Gemfile:

    gem "blamestamp"

Or, if you like to live on the bleeding-edge:

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

Additionally, `blameable` adds 2 relations to your models:

* `blame_cre_user`
* `blame_upd_user`

These are standard `belongs_to` associations, and will be nil unless the `_at` column is populated.

Overriding Stamps
-----------------

If you want, you can manually set the blamestamps instead of letting the remote user set them.  For example:

    user1 = User.new
    foo1 = Foo.new
    foo1.blame_cre_user = user1
    foo1.save!
    #whatever the remote user may have been, blame_cre_by is now user1.id

Advanced Options
----------------

If that's not enough for you, there are several advanced config options available.

### In your migrations:

If you don't like the `blame` prefix on the columns, you can change it.  In this example it will create columns `blah_cre_at`, `blah_upd_at`, `blah_cre_by`, and `blah_upd_by`.

    t.blamestamps :prefix => :blah

### In your model:

If you changed the prefix of the columns in your migration, you should let the model know about that too:

    blameable :prefix => :blah

Or, if you picked something completely off-the-wall in your migration, you can specify each of the 4 columns individually:

    blameable :cre_at => :made_at, :upd_at => :changed_at, :cre_by => :invented_by, :upd_by => :hacked_by

And if you don't like the default association names, you can define those too:

    blameable :cre_user => :inventor, :upd_user => :hacker

If you're concerned about data validation, you can make sure errors are raised if a record is ever saved with a blank `blame_cre_by`:

    blameable :required => true

Finally, you can cascade modifications from a `blameable` model to one of its associations.  Whenever a record of the `blameable` class is inserted, updated, or deleted, the `upd_at`/`upd_by` columns on the associated record will be updated.  For example:

    class Foo < ActiveRecord::Base
      belongs_to :bar
      belongs_to :project
      blameable :cascade => [:project, :bar]
    end

Or, just specify a single cascade:

    class Foo < ActiveRecord::Base
      belongs_to :bar
      belongs_to :project
      blameable :cascade => :bar
    end


Issues and Contributing
-----------------------

Please, let me know about any bugs/feature-requests via the issues tracker.  And if you'd like to contribute, send me a note!  Thanks.


License
-------

Blamestamp is free software, and may be redistributed under the MIT-LICENSE.
