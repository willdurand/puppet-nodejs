puppet-nodejs
=============

Installation
------------

This module doesn't have any hard dependencies but you need `wget` installed.

Get the module:

    git clone git://github.com/willdurand/puppet-nodejs.git modules/nodejs


Usage
-----

Include the `nodejs` class:

    include nodejs


Running the tests
-----------------

Install the dependencies using [Bundler](http://gembundler.com):

    BUNDLE_GEMFILE=.gemfile bundle install

Run the following command:

    BUNDLE_GEMFILE=.gemfile bundle exec rake spec


License
-------

puppet-nodejs is released under the MIT License. See the bundled LICENSE file
for details.
