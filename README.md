puppet-nodejs
=============

[![Build
Status](https://travis-ci.org/willdurand/puppet-nodejs.png?branch=master)](https://travis-ci.org/willdurand/puppet-nodejs)

This module allows to install [Node.js](http://nodejs.org/) and
[NPM](https://npmjs.org/). This module is published on the Puppet Forge as
[willdurand/nodejs](http://forge.puppetlabs.com/willdurand/nodejs).


Installation
------------

### Manuall installation

This modules depends on
[puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) and [maestrodev/puppet-wget](https://github.com/maestrodev/puppet-wget). 
so all repositories have to be checked out:

```bash
git clone git://github.com/willdurand/puppet-nodejs.git modules/nodejs
git clone git://github.com/puppetlabs/puppetlabs-stdlib.git modules/stdlib
git clone git://github.com/maestrodev/puppet-wget.git modules/wget
```

### Puppet Module Tool:

    puppet module install willdurand/nodejs

### Librarian-puppet

    mod 'willdurand/nodejs', '1.6.0'

Usage
-----

There are a few ways how to use this puppet module. The easiest one is just using the class definition

```puppet
class { 'nodejs':
  version => 'v0.10.25',
}
```
This will compile and install Node.js version `v0.10.25` to your machine. `node` and `npm` will be available in your `$PATH` via `/usr/local/node/node-current/bin` so you can just start using `node`. 

Shortcuts are provided to easily install the `latest` or `stable` release by setting the `version` parameter to `latest` or `stable`. It will automatically look for the last release available on http://nodejs.org.

```puppet
class { 'nodejs':
  version => 'stable',
}
```

### Setup using pre-built installer

To use the pre-built installer version provided via http://nodejs.org/download you have to set `make_install` to `false`

```puppet
class { 'nodejs':
  version      => 'stable',
  make_install => false,
}
```

### Setup multiple versions of Node.js

If you need mode than one installed version of Node.js on your machine, you can just do it using the `nodejs::install` puppet define.

```puppet
nodejs::install { 'v0.10.17':
  version => 'v0.10.17',
}
nodejs::install { 'v0.10.25':
  version => 'v0.10.25',
}
```

This snippet will install version `v0.10.17` and `v0.10.25` on your machine. Keep in mind that a Node.js version installed via `nodejs::install` will provide only versioned binaries inside `/usr/local/bin`!

```
/usr/local/bin/node-v0.10.17
/usr/local/bin/npm-v0.10.17

/usr/local/bin/node-v0.10.25
/usr/local/bin/npm-v0.10.25
```

By default, this module creates a symlink for the node binary (and npm) with Node.js version appended into `/usr/local/bin` e.g. `/usr/local/bin/node-v0.10.17`.
All parameters available in the `class` definition are also available for `nodejs::install`.

### Binary path

`node` and `npm` are linked to `/usr/local/bin` to be available in your system `$PATH` by default. To link those binaries to e.g `/bin`, just set the parameter `target_dir`.

```puppet
class { 'nodejs':
  version    => 'stable',
  target_dir => '/bin',
}
```

### NPM

Also, this module installs [NPM](https://npmjs.org/) by default. Since versions `v0.6.3` of Node.js `npm` is included in every installation! For older versions, you can set parameter `with_npm => false` to not install `npm`.


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
