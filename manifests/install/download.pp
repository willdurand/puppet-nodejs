# = Define: nodejs::install::download
#
# == Parameters:
#
# [*source*]
#   Source to fetch for wget.
#
# [*destination*]
#   Local destination of the file to download.
#
# [*unless_test*]
#   Test whether the destination is already in use.
#
define nodejs::install::download(
  $source,
  $destination,
  $unless_test = true
) {
  ensure_packages(['wget'])

  if $caller_module_name != $module_name {
    warning('::nodejs::install::download is not meant for public use!')
  }

  $creates = $unless_test ? {
    true    => $destination,
    default => undef,
  }

  exec { "nodejs-wget-download-${source}-${destination}":
    command => "wget --output-document ${destination} ${source}",
    creates => $creates,
    path    => $::path,
    require => [
      Package['wget'],
    ],
  }
}
