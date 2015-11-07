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
If you wish to create GitLab's user if missing please add export environment variable `PKG_ADD_USER='yes'`
To disable this feature `unset` this variable.

- - - -
For configuration help, you can visit:  
* Official documentation: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md  
* Our [HOWTO page](https://code.nix.org.ua/Slackware/slackbuilds/wikis/gitlab-howto).

