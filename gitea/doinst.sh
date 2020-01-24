add_user_group() {
  if [ "${PKG_ADD_USER}" = 'yes' ]; then
    GITEAGROUP='%GITEAGROUP%'
    GITEAGID=%GITEAGID%
    GITEAUSER='%GITEAUSER%'
    GITEAUID=%GITEAUID%
    # Add group if missing
    if ! grep -q "^${GITEAGROUP}:" /etc/group ; then
      groupadd -g ${GITEAGID} ${GITEAGROUP}
    fi
    # Add user if missing
    if ! grep -q "^${GITEAUSER}:" /etc/passwd ; then
      useradd -u ${GITEAUID} -g ${GITEAGROUP} -d /var/lib/gitea -s /bin/bash -c "User for Gitea" ${GITEAUSER}
    fi
  fi
}

add_user_group
