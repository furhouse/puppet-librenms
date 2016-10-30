# == Class: librenms::params
#
# Parameter class for libremms
#
# === Authors
#
# Andre Timmermann librenms@darktim.de
#
# === Copyright
#
# Copyright (C) 2016 Andre Timmermann
#
class librenms::params {
  $librenms_user              = 'librenms'
  $librenms_group             = 'librenms'
  $install_dir                = '/opt/librenms'
  $git_source                 = 'https://github.com/librenms/librenms.git'
  $configure_mysql            = true
  $configure_cron             = true
  $collector                  = true
  $mysql_db                   = 'librenms'
  $mysql_user                 = 'librenms'
  $mysql_pass                 = undef
  $poller_threads             = 16
  $cron_poller_wrapper_minute = '*/5'
  $cron_poller_wrapper_hour   = '*'
  $cron_discover_new_minute   = '*/5'
  $cron_discover_new_hour     = '*'
  $cron_discover_all_minute   = '33'
  $cron_discover_all_hour     = '*/6'
  $cron_daily_minute          = '15'
  $cron_daily_hour            = '0'
  $cron_alerts_minute         = '*'
  $cron_alerts_hour           = '*'
  $cron_check_services_minute = '*/5'
  $cron_check_services_hour   = '*'
  $manage_git                 = true
  $manage_mysql               = false
}
