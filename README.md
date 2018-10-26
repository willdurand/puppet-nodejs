puppet-nodejs
=============

[![BuildStatus](https://travis-ci.org/willdurand/puppet-nodejs.png?branch=master)](https://travis-ci.org/willdurand/puppet-nodejs)
[![Puppet Forge](https://img.shields.io/puppetforge/v/willdurand/nodejs.svg)](https://forge.puppetlabs.com/willdurand/nodejs)

This module allows you to install [Node.js](https://nodejs.org/) and
[NPM](https://npmjs.org/). This module is published on the Puppet Forge as
[willdurand/nodejs](https://forge.puppetlabs.com/willdurand/nodejs).

### Announcements

* The `1.9` branch accepts patches to fix issues due to several compatibility breaks with `2.0`,
  however **NO** active development will occur on `1.9` anymore.
  The docs can be reviewed on the [1.9 branch](https://github.com/willdurand/puppet-nodejs/tree/1.9).

## Installation

The module depends on the following well-adopted and commonly used modules:

* [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
* [puppetlabs/gcc](https://github.com/puppetlabs/puppetlabs-gcc)

The easiest approach to install this module is by using [r10k](https://github.com/puppetlabs/r10k):

``` ruby
forge 'http://forge.puppetlabs.com'

mod 'willdurand/nodejs', '2.0.3'
mod 'puppetlabs/stdlib', '5.1.0'
mod 'puppetlabs/gcc', '0.3.0'
```

## Usage

### Deploying a precompiled package

There are a few ways to use this puppet module. The easiest one is just using the class definition
and specify a value for the version to install.

```puppet
class { 'nodejs':
  version => latest,
}
```

This installs the latest precompiled version available on `nodejs.org/dist`. `node` and `npm` will
be available in your `$PATH` at `/usr/local/bin`.

There are several ways to specify a target version of `node`:

* `version => latest` installs the latest version available.
* `version => lts` installs the latest long-term support version.
* `version => '9.x'` installs the latest version from the `v9` series.
* `version => '9.7` installs the latest 9.7 patch release.
* `version => '9.9.0'` installs exactly this version.


### Compiling from source

In order to compile from source with `gcc`, the `make_install` option must be `true`.

```puppet
class { 'nodejs':
  version      => 'lts',
  make_install => true,
}
```

### Setup with a given download timeout

Due to infrastructures with slower connections the download timeout of the nodejs binaries can be increased
or disabled:

``` puppet
class { '::nodejs':
  download_timeout => 0,
}
```

For further information please refer to the
[`timeout` docs in Puppet](https://puppet.com/docs/puppet/5.3/types/exec.html#exec-attributes).

### Setup multiple versions of Node.js

If you need more than one installed version of Node.js on your machine, you can 
configure them using the `instances` list.

```puppet
class { '::nodejs':
  version => lts,
  instances => {
    "node-lts" => {
      version => lts
    },
    "node-9" => {
      version => '9.x'
    }
  },
}
```

This will install the three specified versions (latest version, current LTS version and latest `9.x` of
NodeJS) in `/usr/local/node`.

Important is that the default `node` and `npm` executable's versions need to be specified as
hash in the `instances` list.

The structure of linked executables in `/usr/local/bin` will look like this:

```
/usr/local/bin/node           # latest (default, linked to LTS in this case)
/usr/local/bin/node-v9.x.x    # latest 9.x
/usr/local/bin/node-v8.x.x    # latest LTS (ATM)

/usr/local/bin/npm            # NPM shipped with v8.x.x
/usr/local/bin/npm-v9.x.x     # NPM shipped with NodeJS 9.x
/usr/local/bin/npm-v8.x.x     # NPM shipped with NodeJS LTS
```

It is also possible to remove a single version like this:

```puppet
class { '::nodejs':
  # ...
  instances_to_remove => ['9.x.x'],
}
```

**Please** keep in mind that `instances_to_remove` doesn't remove version specifier like `lts` or
`latest`.

### Setup using custom amount of cpu cores

By default, all available cpu (that are detected using the `::processorcount` fact)  cores
are being used to compile nodejs. Set `cpu_cores` to any number of cores you want to use.
This is mainly intended for the use with `make_install => true` for parallelisation purposes.

```puppet
class { 'nodejs':
  version      => 'lts',
  cpu_cores    => 2,
  make_install => true,
}
```

### Configuring `$NODE_PATH`

The environment variable `$NODE_PATH` can be configured using the `init` manifest:

```puppet
class { '::nodejs':
  version   => 'lts',
  node_path => '/your/custom/node/path',
}
```

It is not possible to adjust a `$NODE_PATH` through ``::nodejs::install``.

### Binary path

`node` and `npm` are linked to `/usr/local/bin` to be available in your system `$PATH`
by default. To link those binaries to a different directory such as `/bin`, the parameter `target_dir`
can be modified accordingly:

```puppet
class { 'nodejs':
  version    => 'lts',
  target_dir => '/bin',
}
```

### NPM Provider

NPM packages can be installed just like any else package using Puppet's `package`
type, but with a special provider, namely `npm`:

```puppet
package { 'express':
  provider => npm
}
```

Note: When deploying a new machine without `nodejs` already installed, your npm
package definition requires the nodejs class:

```puppet
class { 'nodejs':
  version => 'lts'
}

package { 'express':
  provider => 'npm',
  require  => Class['nodejs']
}
```

### NPM installer

The `nodejs` installer can be used if a npm package should not be installed globally, but in a
certain directory.

There are two approaches how to use this feature:

#### Installing a single package into a directory

```puppet
::nodejs::npm { 'npm-webpack':
  ensure    => present, # absent would uninstall this package
  pkg_name  => 'webpack',
  version   => 'x.x',               # optional
  options   => '-x -y -z',          # CLI options passed to the "npm install" cmd, optional
  exec_user => 'vagrant',           # exec user, optional
  directory => '/target/directory', # target directory
  home_dir  => '/home/vagrant',     # home directory of the user which runs the installation (vagrant in this case)
}
```

This would install the package ``webpack`` into ``/target/directory`` with version ``x.x``.

#### Executing a ``package.json`` file

```puppet
::nodejs::npm { 'npm-install-dir':
  list      => true,       # flag to tell puppet to execute the package.json file
  directory => '/target',
  exec_user => 'vagrant',
  options   => '-x -y -z',
}
```

### Proxy

When your puppet agent is behind a web proxy, export the `http_proxy` environment variable:

```bash
export http_proxy=http://myHttpProxy:8888
```

### Skipping package setup

As discussed in [willdurand/composer#44](https://github.com/willdurand/puppet-composer/issues/44)
each module should get a `build_deps` parameter which can be used in edge cases in order to turn
the package setup of this module off:

``` puppet
class { '::nodejs':
  build_deps => false,
}
```

In this case you'll need to take care of the following packages:

- `tar`
- `ruby`
- `wget`
- `semver` (GEM used by ruby)
- `make` (if `make_install` = `true`)
- `gcc` compiler (if `make_install` = `true`)

## Hacking

The easiest way to get started is using [`bundler`](https://bundler.io):

```
bundle install
bundle exec rake test
```

For a completely isolated shell which can be used for further devtools, [`nix`](https://nixos.org/nix/)
can be used as well:

```
nix-shell
rake test
```

## Authors

* William Durand (<william.durand1@gmail.com>)
* Johannes Graf ([@grafjo](https://github.com/grafjo))
* Maximilian Bosch ([@Ma27](https://github.com/Ma27))


## License

puppet-nodejs is released under the [MIT License](https://opensource.org/licenses/MIT). See the bundled
LICENSE file for details.
