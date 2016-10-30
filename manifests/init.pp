# == Class: librenms
#
# Installs LibreNMS (http://www.librenms.org)
#
# === Parameters
#
# $librenms_user:              = User to be created/used by LibreNMS.
#                                type: string
#
# $librenms_group:             = Group to be created/used by LibreNMS.
#                                type: string
#
# $install_dir:                = The install directory for the git checkout.
#                                type: absolute path
#
# $git_source                  = The librenms git repository to be used.
#                                type: string
#
# $configure_mysql:            = If you want to use librenms::mysql to set up the
#                                database.
#                                type: boolean
#
# $configure_cron:             = If you want to use librenms::cron to set up the
#                                cronjobs.
#                                type: boolean
#
# $collector:                  = If you want to use librenms::add_device
#                                collector so that all hosts with class
#                                librenms::device will be added to LibreNMS
#
# $mysql_db:                   = Mysql database used by librenms::mysql.
#
# $mysql_user:                 = Mysql user used by librenms::mysql.
#                                type: string
#
# $mysql_pass:                 = Mysql password used by librenms::mysql.
#                                type: string
#
# $poller_threads:             = By default, the cron job runs poller-wrapper.py
#                                with 16 threads. The current recommendation is to
#                                use 4 threads per core as a rule of thumb.
#
# $cron_poller_wrapper_minute: = Minute when the poller-wrapper should run.
#                                type: string
#
# $cron_poller_wrapper_hour:   = Hour when the poller-wrapper should run.
#                                type: string
#
# $cron_discover_new_minute:   = Minute when new devices should be discovered.
#                                type: string
#
# $cron_discover_new_hour:     = Hour when new devices should be discovered.
#                                type: string
#
# $cron_discover_all_minute:   = Minute when new devices should be
#                                (re)-discovered.
#                                type: string
#
# $cron_discover_all_hour:     = Hour when new devices should be (re)-discovered.
#                                type: string
#
# $cron_daily_minute:          = Minute when the daily cronjobs should run.
#                                type: string
#
# $cron_daily_hour:            = Hour when the daily cronjobs should run.
#                                type: string
#
# $cron_alerts_minute:         = Minute when the alerting cronjob should run.
#                                type: string
#
# $cron_alerts_hour:           = Hour when the alerting cronjob should run.
#                                type: string
#
# $cron_check_services_minute: = Hour when the services check cronjob should run.
#                                type: string
#
# $cron_check_services_hour:   = Hour when the services check cronjob should run.
#                                type: string
#
# $manage_git:                 = Install git.
#                                type: boolean
#
# $manage_mysql:               = Install mysql.
#                                type: boolean
#
# === Examples
#
# class { '::librenms':
#   mysql_pass => 'superstrongpass'
# }
#
# You HAVE to provide a password for the mysql database (librenms::mysql).
# If you do not want to use the librenms::mysql, please disable it ;)
#
# Please refer to the readme for setting up the webserver.
#
# === Authors
#
# Andre Timmermann librenms@darktim.de
#
# === Copyright
#
# Copyright (C) 2016 Andre Timmermann
#
class librenms (
  $librenms_user              = $librenms::params::librenms_user,
  $librenms_group             = $librenms::params::librenms_group,
  $install_dir                = $librenms::params::install_dir,
  $git_source                 = $librenms::params::git_source,
  $configure_mysql            = $librenms::params::configure_mysql,
  $configure_cron             = $librenms::params::configure_cron,
  $collector                  = $librenms::params::collector,
  $mysql_db                   = $librenms::params::mysql_db,
  $mysql_user                 = $librenms::params::mysql_user,
  $mysql_pass                 = $librenms::params::mysql_pass,
  $poller_threads             = $librenms::params::poller_threads,
  $cron_poller_wrapper_minute = $librenms::params::cron_poller_wrapper_minute,
  $cron_poller_wrapper_hour   = $librenms::params::cron_poller_wrapper_hour,
  $cron_discover_new_minute   = $librenms::params::cron_discover_new_minute,
  $cron_discover_new_hour     = $librenms::params::cron_discover_new_hour,
  $cron_discover_all_minute   = $librenms::params::cron_discover_all_minute,
  $cron_discover_all_hour     = $librenms::params::cron_discover_all_hour,
  $cron_daily_minute          = $librenms::params::cron_daily_minute,
  $cron_daily_hour            = $librenms::params::cron_daily_hour,
  $cron_alerts_minute         = $librenms::params::cron_alerts_minute,
  $cron_alerts_hour           = $librenms::params::cron_alerts_hour,
  $cron_check_services_minute = $librenms::params::cron_check_services_minute,
  $cron_check_services_hour   = $librenms::params::cron_check_services_hour,
  $manage_git                 = $librenms::params::manage_git,
  $manage_mysql               = $librenms::params::manage_mysql,
) inherits librenms::params {

  validate_string($git_source, $librenms_user, $librenms_group, $mysql_db, $mysql_pass, $cron_poller_wrapper_minute)
  validate_string($cron_poller_wrapper_hour, $cron_discover_new_minute, $cron_discover_new_hour, $cron_discover_all_minute)
  validate_string($cron_discover_all_hour, $cron_daily_minute, $cron_daily_hour, $cron_alerts_minute, $cron_alerts_hour)
  validate_string($cron_check_services_minute, $cron_check_services_hour)
  validate_absolute_path($install_dir)
  validate_integer($poller_threads)
  validate_bool($configure_mysql, $configure_cron, $manage_git, $manage_mysql)

  # fail if db password is empty
  if $mysql_pass == undef {
    fail('mysql_pass may not be empty')
  }
  else {
    validate_string($mysql_pass)
  }

  group { $librenms_group:
      ensure => present,
      system => true;
  }

  user { $librenms_user:
      ensure     => present,
      comment    => 'LibreNMS system user',
      managehome => false,
      system     => true,
      gid        => $librenms_group,
      home       => $install_dir,
      require    => Group[$librenms_group];
  }

  # installs librenms via git clone
  include librenms::install

  # installs/configures mysql
  if $configure_mysql {
    include librenms::mysql
  }

  # configures cronjobs
  if $configure_cron {
    include ::librenms::cron
  }

  # adds the collector of devices
  if $collector {
    include librenms::add_device
  }
}
