add_user_group() {
  if [ "${PKG_ADD_USER}" = 'yes' ]; then
    WOODPECKERGROUP='%WOODPECKERGROUP%'
    WOODPECKERGID=%WOODPECKERGID%
    WOODPECKERUSER='%WOODPECKERUSER%'
    WOODPECKERUID=%WOODPECKERUID%
    # Add group if missing
    if ! grep -q "^${WOODPECKERGROUP}:" /etc/group ; then
      groupadd -g ${WOODPECKERGID} ${WOODPECKERGROUP}
    fi
    # Add user if missing
    if ! grep -q "^${WOODPECKERUSER}:" /etc/passwd ; then
      useradd -u ${WOODPECKERUID} -g ${WOODPECKERGROUP} -d /var/lib/woodpecker -s /usr/bin/false -c "User for Woodpecker" ${WOODPECKERUSER}
    fi
  fi
}

add_user_group
