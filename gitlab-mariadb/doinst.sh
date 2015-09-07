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
  GITLABHOME=%GITLABHOME%
  # Add group if missing
  if ! grep -q "^${GITLABGROUP}:" /etc/group ; then
    groupadd -g ${GITLABGID} ${GITLABGROUP}
  fi
  # Add user if missing
  if ! grep -q "^${GITLABUSER}:" /etc/passwd ; then
    useradd -u ${GITLABUID} -g ${GITLABGROUP} -d /${GITLABHOME} -s /bin/bash -c "User for GitLab" ${GITLABUSER}
  fi
}

add_user_group
preserve_perms %GITLABHOME%/.bash_profile.new
preserve_perms %GITLABHOME%/.bashrc.new
config %DOCROOT%/config.ru.new
config %DOCROOT%/config/unicorn.rb.new
config %DOCROOT%/config/gitlab.yml.new
config %DOCROOT%/config/resque.yml.new
config %DOCROOT%/config/database.yml.new
config %DOCROOT%/config/environments/production.rb.new
config etc/default/gitlab.new
config etc/cron.daily/gitlab-backup.new
preserve_perms etc/rc.d/rc.gitlab-sidekiq.new
preserve_perms etc/rc.d/rc.gitlab-unicorn.new
