puppet-nodejs
=============

[![Build
Status](https://travis-ci.org/willdurand/puppet-nodejs.png?branch=master)](https://travis-ci.org/willdurand/puppet-nodejs)

This module allows to install [Node.js](http://nodejs.org/) and
[NPM](https://npmjs.org/). This module is published on the Puppet Forge as
[willdurand/nodejs](http://forge.puppetlabs.com/willdurand/nodejs).


Installation
------------

Get the module by cloning the repository:

    git clone git://github.com/willdurand/puppet-nodejs.git modules/nodejs

Or use the Puppet Module Tool:

    puppet module install willdurand/nodejs


Requirements
------------

This modules depends on
[puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) and [maestrodev/puppet-wget](https://github.com/maestrodev/puppet-wget). You MUST
clone them if you don't use the Puppet Module Tool:

    git clone git://github.com/puppetlabs/puppetlabs-stdlib.git modules/stdlib
    git clone git://github.com/maestrodev/puppet-wget.git modules/wget


Usage
-----

Include the `nodejs` class:

```puppet
include nodejs
```

You can specify a Node.js version by specifing it:

```puppet
class { 'nodejs':
  version => 'v0.10.17',
}
```

You can install different versions of Node.js thanks to the `nodejs::install`
definition:

```puppet
nodejs::install { 'v0.10.17':
  version => 'v0.10.17',
}
```

Shortcuts are provided to easily install the 'latest' or 'stable' release by
setting the `version` parameter to `latest` or `stable`. It will
automatically look for the last release available.

```puppet
class { 'nodejs':
  version => 'stable',
}
```

By default, this module creates symlinks for each Node.js version installed into
`/usr/local/bin`. A nodejs::install define creates a versioned symlink like `/usr/local/bin/node-v0.10.17`. The class `nodejs` creates the default symlink `/usr/local/bin/node`. You can change this behavior by using the `target_dir` parameter.

Also, this module installs [NPM](https://npmjs.org/) by default. You can set the
`with_npm` parameter to `false` to not install it.

This module will `make install` Node.js by default, to use prebuilt versions
distributed by Node.js on http://nodejs.org/dist/ set the `make_install`
parameter to `false`.

```puppet
class { 'nodejs':
  version => 'v0.10.17',
  make_install => false,
}
```

or

```puppet
nodejs::install { 'v0.10.17':
  version => 'v0.10.17',
  make_install => false,
}
```


### NPM Provider

This module adds a new provider: `npm`. You can use it as usual:

```puppet
package { 'express':
  provider => npm
}
```


Running the tests
-----------------

Install the dependencies using [Bundler](http://gembundler.com):

    BUNDLE_GEMFILE=.gemfile bundle install

Run the following command:

    BUNDLE_GEMFILE=.gemfile bundle exec rake test


Authors
-------

* William Durand <william.durand1@gmail.com>
* Johannes Graf ([@grafjo](https://github.com/grafjo))


License
-------

puppet-nodejs is released under the MIT License. See the bundled LICENSE file
for details.
