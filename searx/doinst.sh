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
  OLD="$(dirname ${NEW})/$(basename ${NEW} .new)"
  if [ -e ${OLD} ]; then
    cp -a ${OLD} ${NEW}.incoming
    cat ${NEW} > ${NEW}.incoming
    mv ${NEW}.incoming ${NEW}
  fi
  config ${NEW}
}

add_user_group() {
  if [ "${PKG_ADD_USER}" = 'yes' ]; then
    SEARXGROUP='%SEARXGROUP%'
    SEARXGID=%SEARXGID%
    SEARXUSER='%SEARXUSER%'
    SEARXUID=%SEARXUID%
    SEARXHOME='%DOCROOT%'
    # Add group if missing
    if ! grep -q "^${SEARXGROUP}:" /etc/group ; then
      groupadd -g ${SEARXGID} ${SEARXGROUP}
    fi
    # Add user if missing
    if ! grep -q "^${SEARXUSER}:" /etc/passwd ; then
      useradd -u ${SEARXUID} -g ${SEARXGROUP} -d ${SEARXHOME} -s /bin/false -c "User for Searx" ${SEARXUSER}
    fi
  fi
}

add_user_group
config %DOCROOT%/searx/settings.yml.new

