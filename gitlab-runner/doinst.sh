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
  if [ "${PKG_ADD_USER}" = 'yes' ]; then
    GITLABRUNNERGROUP='%GITLABRUNNERGROUP%'
    GITLABRUNNERGID=%GITLABRUNNERGID%
    GITLABRUNNERUSER='%GITLABRUNNERUSER%'
    GITLABRUNNERUID=%GITLABRUNNERUID%
    GITLABRUNNERHOME='%GITLABRUNNERHOME%'
    # Add group if missing
    if ! grep -q "^${GITLABRUNNERGROUP}:" /etc/group ; then
      groupadd -g ${GITLABRUNNERGID} ${GITLABRUNNERGROUP}
    fi
    # Add user if missing
    if ! grep -q "^${GITLABRUNNERUSER}:" /etc/passwd ; then
      useradd -u ${GITLABRUNNERUID} -g ${GITLABRUNNERGROUP} -d /${GITLABRUNNERHOME} -s /bin/bash -c "User for GitLab CI runner" ${GITLABRUNNERUSER}
      passwd -l ${GITLABRUNNERUSER}
    fi
  fi
}

add_user_group
preserve_perms etc/rc.d/rc.gitlab-runner.new
