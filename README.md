puppet-nodejs
=============

[![Build
Status](https://travis-ci.org/willdurand/puppet-nodejs.png?branch=master)](https://travis-ci.org/willdurand/puppet-nodejs)

This module allows you to install [Node.js](https://nodejs.org/) and
[NPM](https://npmjs.org/). This module is published on the Puppet Forge as
[willdurand/nodejs](https://forge.puppetlabs.com/willdurand/nodejs).

Version 1.9
-----------

The 1.x branch will be EOLed two months after ``2.0`` is released.
If you need the docs for 1.x, see [1.9](https://github.com/willdurand/puppet-nodejs/tree/1.9).

Installation
------------

### Manual installation

This modules depends on
[puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib).
So all repositories have to be checked out:

```bash
git clone git://github.com/willdurand/puppet-nodejs.git modules/nodejs
git clone git://github.com/puppetlabs/puppetlabs-stdlib.git modules/stdlib
```

For Redhat based OS, the following are (typical) additional requirements:

```bash
git clone git://github.com/treydock/puppet-gpg_key.git modules/gpg_key
```

### Puppet Module Tool:

    puppet module install willdurand/nodejs

### Librarian-puppet:

    mod 'willdurand/nodejs', '1.x.x'

Usage
-----

There are a few ways to use this puppet module. The easiest one is just using the class definition:

```puppet
class { 'nodejs':
  version => 'v6.0.0',
}
```
This will compile and install Node.js version `v6.0.0` to your machine. `node` and `npm` will be available in your `$PATH` via `/usr/local/node/node-default/bin` so you can just start using `node`.

Shortcuts are provided to easily install the `latest` or `stable` release by setting the `version` parameter to `latest` or `stable`. It will automatically look for the last release available on https://nodejs.org.

```puppet
class { 'nodejs':
  version => 'stable',
}
```

### Setup using the pre-built installer

To use the pre-built installer version provided via https://nodejs.org/download you have to set `make_install` to `false`

```puppet
class { 'nodejs':
  version      => 'stable',
  make_install => false,
}
```

### Setup with a given download timeout

Due to infrastructures with slower connections the download of the nodejs binaries should be
configurable:

``` puppet
::Nodejs::Install::Download {
  timeout => 300
}

class { '::nodejs':
  make_install => false,
}
```

### Setup multiple versions of Node.js

If you need more than one installed version of Node.js on your machine, you can just do it using the `nodejs::install` puppet define.

```puppet
nodejs::install { 'v6.0.0':
  version => 'v6.0.0',
}
nodejs::install { 'v5.0.0':
  version => 'v5.0.0',
}
```

This snippet will install version `v6.0.0` and `v5.0.0` on your machine. Keep in mind that a Node.js version installed via `nodejs::install` will provide only versioned binaries inside `/usr/local/bin`!

```
/usr/local/bin/node-v6.0.0
/usr/local/bin/npm-v6.0.0

/usr/local/bin/node-v5.0.0
/usr/local/bin/npm-v5.0.0
```

By default, this module creates a symlink for the node binary (and npm) with Node.js version appended into `/usr/local/bin` e.g. `/usr/local/bin/node-v5.0.0`.
All parameters available in the `class` definition are also available for `nodejs::install`.

It is also possible to remove those versions again:

```puppet
::nodejs::install { 'node-v5.4':
  ensure  => absent,
  version => 'v5.4.1',
}
```

After the run the directory __/usr/local/node/node-v5.4.1__ has been purged.
The link __/usr/local/bin/node-v5.4.1__ is also purged.

__Note:__ It is not possible to install and uninstall an instance in the same run.

When attempting to remove the default instance this can be only done when having the ``::nodejs`` class __NOT__ defined as otherwise ``duplicate resource`` errors would occur. 
After that no new default instance will be configured.

### Setup using custom amount of cpu cores

By default, all available cpu cores are being used to compile nodejs. Set `cpu_cores` to any number of cores you want to use.

```puppet
class { 'nodejs':
  version   => 'stable',
  cpu_cores => 2,
}
```

### Configuring $NODE_PATH

The environment variable $NODE_PATH can be configured using the `init` manifest:

```puppet
class { '::nodejs':
  version   => 'latest',
  node_path => '/your/custom/node/path',
}
```

It is not possible to adjust a $NODE_PATH through ``::nodejs::install``.

### Binary path

`node` and `npm` are linked to `/usr/local/bin` to be available in your system `$PATH` by default. To link those binaries to e.g `/bin`, just set the parameter `target_dir`.

```puppet
class { 'nodejs':
  version    => 'stable',
  target_dir => '/bin',
}
```

### NPM

Also, this module installs [NPM](https://npmjs.org/) by default.

### NPM Provider

This module adds a new provider: `npm`. You can use it as usual:

```puppet
package { 'express':
  provider => npm
}
```

Note: When deploying a new machine without nodejs already installed, your npm package definition requires the nodejs class:

```puppet
class { 'nodejs':
  version => 'stable'
}

package { 'express':
  provider => 'npm',
  require  => Class['nodejs']
}
```

### NPM installer

The nodejs installer can be used if a npm package should not be installed globally, but in a certain directory.

There are two approaches how to use this feature:

#### Installing a single package into a directory

```puppet
::nodejs::npm { 'npm-webpack':
  ensure       => present, # absent would uninstall this package
  pkg_name     => 'webpack',
  version      => 'x.x', # optional
  install_opt  => '-x -y -z', # options passed to the "npm install" cmd, optional
  remove_opt   => '-x -y -z', # options passed to the "npm remove" cmd (in case of ensure => absent), optional
  exec_as_user => 'vagrant',  # exec user, optional
  directory    => '/target/directory', # target directory
}
```

This would install the package ``webpack`` into ``/target/directory`` with version ``x.x``.

#### Executing a ``package.json`` file

```puppet
::nodejs::npm { 'npm-install-dir':
  list         => true, # flag to tell puppet to execute the package.json file
  directory    => '/target',
  exec_as_user => 'vagrant',
  install_opt  => '-x -y -z',
}
```

### Proxy

When your puppet agent is behind a web proxy, export the `http_proxy` environment variable:

```bash
export http_proxy=http://myHttpProxy:8888
```

Running the tests
-----------------

Install the dependencies using [Bundler](https://bundler.io):

    bundle install

Run the following command:

    bundle exec rake test


Authors
-------

* William Durand <william.durand1@gmail.com>
* Johannes Graf ([@grafjo](https://github.com/grafjo))
* Maximilian Bosch ([@Ma27](https://github.com/Ma27))


License
-------

puppet-nodejs is released under the MIT License. See the bundled LICENSE file
for details.
