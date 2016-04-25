config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

preserve_perms() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

add_user_group() {
  ZABBIXGROUP='%ZABBIXGROUP%'
  ZABBIXGID=%ZABBIXGID%
  ZABBIXAGENTUSER='%ZABBIXAGENTUSER%'
  ZABBIXAGENTUID=%ZABBIXAGENTUID%
  # Add group if missing
  if ! grep -q "^${ZABBIXGROUP}:" /etc/group ; then
    groupadd -g ${ZABBIXGID} ${ZABBIXGROUP}
  fi
  # Add user if missing
  if ! grep -q "^${ZABBIXAGENTUSER}:" /etc/passwd ; then
    useradd -u ${ZABBIXAGENTUID} -g ${ZABBIXGROUP} -d /dev/null -s /bin/false -c "User for Zabbix agent" ${ZABBIXAGENTUSER}
  fi
}

add_user_group
preserve_perms etc/rc.d/rc.zabbix_agentd.new
config etc/zabbix/zabbix_agentd.conf.new
config var/log/zabbix/zabbix_agentd.log.new
rm -f var/log/zabbix/zabbix_agentd.log.new
