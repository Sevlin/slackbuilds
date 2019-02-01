add_user_group() {
  if [ "${PKG_ADD_USER}" = 'yes' ]; then
    DRONEGROUP='%DRONEGROUP%'
    DRONEGID=%DRONEGID%
    DRONEUSER='%DRONEUSER%'
    DRONEUID=%DRONEUID%
    # Add group if missing
    if ! grep -q "^${DRONEGROUP}:" /etc/group ; then
      groupadd -g ${DRONEGID} ${DRONEGROUP}
    fi
    # Add user if missing
    if ! grep -q "^${DRONEUSER}:" /etc/passwd ; then
      useradd -u ${DRONEUID} -g ${DRONEGROUP} -d /var/lib/drone -s /usr/bin/false -c "User for Drone" ${DRONEUSER}
    fi
  fi
}

add_user_group
