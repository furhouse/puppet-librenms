# == Class: librenms::install
#
# This installs librenms via git checkout
#
# === Authors
#
# Andre Timmermann librenms@darktim.de
#
# === Copyright
#
# Copyright (C) 2016 Andre Timmermann
#
class librenms::install (
  $install_dir   = $librenms::install_dir,
  $git_source    = $librenms::git_source,
  $librenms_user = $librenms::librenms_user,
) inherits librenms::params {

  if $librenms::manage_git {
    ensure_packages ('git')
  }

  file { $install_dir:
    ensure => directory,
    owner  => $librenms_user,
    group  => $librenms_user,
    mode   => '0755';
  }

  vcsrepo { $install_dir:
    ensure   => present,
    provider => git,
    user     => $librenms_user,
    source   => $git_source,
    require  => File[$install_dir],
  }

  file { [ "${install_dir}/rrd", "${install_dir}/logs" ]:
    ensure  => directory,
    owner   => $librenms_user,
    group   => $librenms_user,
    mode    => '0775',
    require => Vcsrepo[$install_dir];
  }
}
