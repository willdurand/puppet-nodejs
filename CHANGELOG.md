# ChangeLog

This document lists the changes of all recent versions since `2.0.0`.

## 2.1.0

### Minor breaking changes

* Dropped EOLed Puppet 3.x
* Don't install dev dependencies (`ruby`) anymore with `build_deps => true`. It's only needed on
  the Puppet Master and shouldn't be deployed onto each node.

### Further changes

* Deprecated `::nodejs::npm`. The feature was always out of scope and introduced several hacks
  to support several edge-cases. Instead it's recommended to write a custom module suited
  for your application when deploying dependencies into a given directory.

## 2.0.3

* ([#184](https://github.com/willdurand/puppet-nodejs/issues/184)) Added support
  for [Puppet 6](https://puppet.com/blog/introducing-puppet-6).
* ([#183](https://github.com/willdurand/puppet-nodejs/issues/183)) Added support for `install_options`
  when installing a package using the `npm` provider.

## 2.0.2

* ([#181](https://github.com/willdurand/puppet-nodejs/issues/181)) Instaling `rubygems`
  (when `build_deps => true`) was broken on Ubuntu 14.04.
  See patch [b59c504](https://github.com/willdurand/puppet-nodejs/commit/b59c504218ff3e4064706b3959672983067a680f)
  for further reference.

## 2.0.1

* Added support for [Puppet 5](https://puppet.com/blog/puppet-5-platform-released).
* Install `rubygems` when allowing `puppet-nodejs` to build packages.

## 2.0.0

### Version/Requirement changes

* Dropped support for Node.js versions until `v0.12.0`.
* Dropped support for all Puppet versions below `v3.4`.
* Dropped support for all ruby versions below `v2.1`.

### Code changes

#### Installer Refactoring

* Added `puppetlabs-gcc` for package handling of the compiler (and removed custom implementation).
* Killed the `python_package` option (not needed anymore).
* `nodejs::install` has been replaced by an internal API.
  To use multiple instances, use the `instances` and `instances_to_remove` option of
  the `nodejs` class (see the docs for more details).
* ([willdurand/puppet-composer#44](https://github.com/willdurand/puppet-composer/issues/44)) Introduced a
  new `build_deps` parameter which makes the entire package setup optional.

#### `nodejs::npm` refactoring

The `nodejs::npm` resource has been refactored in order to keep the logic inside maintainable.

The following breaking changes were made:

* Removed `install_opt` and `remove_opt` and replaced it with a single `options` parameter.
* Renamed `exec_as_user` to `exec_user` as it's describes the intent of the parameter in a better way.
* Dropped automatic generation of a home directory for the `npm` calls and added
  a `home_dir` parameter which does the job.
* Removed the ability to write `dir:pkg` as resource title.
* The `pkg_name` has now `$title` as default parameter.

#### Version refactoring

The whole version detection logic was quite outdated and needed a refactoring:

* Removed the `stable` flag for versions. The behavior of `latest` was equal.
* Introduced the `lts` flag to fetch the latest LTS release of Node.js.
* generic versions:
  * `7.x` to fetch the latest release of the Node.js v7 branch.
  * `7.0` to fetch the latest `7.0.x` release.

#### Other notable changes

* Removed the `::nodejs_latest_version` and `::nodejs_stable_version` fact and replaced them with a
  puppet function to avoid evaluations on each node.
* Removed `with_npm` parameter (only used for Node.js 0.6 and below).
* ([#94](https://github.com/willdurand/puppet-nodejs/issues/94)) Proper symlinks for versioned NPM executables.
* Added `cpu_cores` option to speedup the compilation process.
* Changed all downloads from `http` to `https`.
* Remove installation of `git` package.
* Added support for ARM architecture (`armv6l` and `armv7l`).
* Added `download_timeout` parameter to simplify configuration of package download timeouts.
* Dropped `profile.d` script to patch NodeJS paths. Target directory will be set
  with `nodejs::$target_dir` which should be in `$PATH`.
  See [bcfdda3341aa8b0d885b40e9a6ab7f90859f9f3e](https://github.com/willdurand/puppet-nodejs/commit/bcfdda3341aa8b0d885b40e9a6ab7f90859f9f3e) and [#177](https://github.com/willdurand/puppet-nodejs/issues/177) for further reference.
