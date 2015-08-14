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
  GITLABGROUP='%GITLABGROUP%'
  GITLABGID=%GITLABGID%
  GITLABUSER='%GITLABUSER%'
  GITLABUID=%GITLABUID%
  PRGHOME='%PRGHOME%'
  # Add group if missing
  if ! grep -q "^${GITLABGROUP}:" /etc/group ; then
    groupadd -g ${GITLABGID} ${GITLABGROUP}
  fi
  # Add user if missing
  if ! grep -q "^${GITLABUSER}:" /etc/passwd ; then
    useradd -u ${GITLABUID} -g ${GITLABGROUP} -d /${PRGHOME} -s /bin/bash -c "User for GitLab" ${GITLABUSER}
  fi
}

gen_secret() {
  # Generate secret key
  hexdump -v -n "32" -e '1/1 "%02x"' /dev/urandom > ${PRGHOME}/.secret.new
  chown ${GITLABUSER}:${GITLABGROUP} ${PRGHOME}/.secret.new
  chmod 0700 ${PRGHOME}/.secret.new
}

add_user_group
gen_secret
config var/lib/gitlab/config.yml.new
preserve_perms var/lib/gitlab/.secret.new

