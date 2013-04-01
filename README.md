puppet-nodejs
=============

[![Build
Status](https://travis-ci.org/willdurand/puppet-nodejs.png?branch=master)](https://travis-ci.org/willdurand/puppet-nodejs)

This module allows to install [Node.js](http://nodejs.org/) and
[NPM](https://npmjs.org/).


Installation
------------

This module doesn't have any hard dependencies but you need:
`python`, `g++`, `make`, `wget` and `tar` installed.

Get the module:

    git clone git://github.com/willdurand/puppet-nodejs.git modules/nodejs


Usage
-----

Include the `nodejs` class:

    include nodejs

You can specify a Node.js version by specifing it:

    class { 'nodejs':
      version => 'v0.8.0',
    }

You can install different versions of Node.js thanks to the `nodejs::install`
definition:

    nodejs::install { 'v0.7.0':
      version => 'v0.7.0',
    }

By default, this module creates symlinks for each Node.js version installed into
`/usr/local/bin`. You can change this behavior by using the `target_dir`
parameter.

Also, this module installs [NPM](https://npmjs.org/) by default. You can set the
`with_npm` parameter to `false` to not install it.


### NPM Provider

This module adds a new provider: `npm`. You can use it as usual:

    package { 'bower':
      provider => npm
    }


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
