# == Class: librenms::mysql
#
# Installs the mysql database for LibreNMS. It uses the puppetlabs/mysql module.
#
# === Parameters
#
# Please refer to params.pp for all parameters used in this module.
#
# === Authors
#
# Andre Timmermann librenms@darktim.de
#
# === Copyright
#
# Copyright (C) 2016 Andre Timmermann
#
class librenms::mysql (
  $mysql_db   = $librenms::mysql_db,
  $mysql_user = $librenms::mysql_user,
  $mysql_pass = $librenms::mysql_pass,
) inherits librenms::params {

  if $librenms::configure_mysql {
    include ::mysql::server

    # deploy databases
    mysql::db { $mysql_db:
      user     => $mysql_user,
      password => $mysql_pass,
      host     => 'localhost',
      grant    => ['all'],
      require  => Class['mysql::server'];
    }
  }
}
