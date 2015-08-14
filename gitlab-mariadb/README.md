*GitLab CE* (Community Edition) is a web-based Git repository manager with wiki and issue tracking features. Self-hosted alternative to GitHub.

- - - -
You can override **DOCROOT**, **PRGHOME**, **PIDDIR**, **LOGDIR**,  **GITLABUSER**, **GITLABGROUP**, **GITLABUID**, **GITLABGID** and **RAILS_ENV** at build time.  

They default to:
* DOCROOT=var/www
* PRGHOME=var/lib/gitlab
* PIDDIR=var/run/gitlab
* LOGDIR=var/log/gitlab
* GITLABUSER=git
* GITLABGROUP=git
* GITLABUID=507
* GITLABGID=507
* RAILS_ENV=production

- - - -
:warning: **WARNING** :warning:  
During package installation **[doinst.sh](gitlab-mariadb/doinst.sh)** will attempt to create GitLab's user if missing.
To disable this feature comment out or delete `add_user_group()` function and/or it's call.

- - - -
For configuration help, you can visit:  
* Official documentation: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md  
* Our [HOWTO page](https://code.nix.org.ua/Slackware/slackbuilds/wikis/gitlab-howto).

