*GitLab Shell* handles git commands for GitLab and modifies the list of authorized keys. GitLab Shell is not a Unix shell nor a replacement for Bash or Zsh.

- - - -
You can override **DOCROOT**, **PRGHOME**, **LOGDIR**, **GITLABUSER**, **GITLABGROUP**, **GITLABUID**, **GITLABGID** and **RAILS_ENV** at build time.  

They default to:
* DOCROOT=var/www
* PRGHOME=var/lib/gitlab
* LOGDIR=var/log/gitlab
* GITLABUSER=git
* GITLABGROUP=git
* GITLABUID=507
* GITLABGID=507
* RAILS_ENV=production

- - - -
:warning: **WARNING** :warning:  
During package installation **[doinst.sh](gitlab-shell/doinst.sh)** will attempt to create GitLab's user if missing.
To disable this feature comment out or delete `add_user_group()` function and/or it's call.

- - - -
For configuration help, you can visit:  
* Official documentation: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md  
* Our [HOWTO page](https://code.nix.org.ua/Slackware/slackbuilds/wikis/gitlab-howto).

