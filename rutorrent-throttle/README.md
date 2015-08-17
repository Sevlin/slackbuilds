*Throttle* plugin gives a convenient control over this possibility. After this plugin is installed a new option "Channels" will appear in the Settings dialog. Speed limits for some (by default - 10) channels can be set here. Assignment of channel number for a particular torrent or for a group of torrents can be made in it's contextual menu. Note - "0"-value, conventionally for rtorrent, means "no limits", but not "stop torrent". So the lowest possible limit is 1 Kbps.

- - - -

You can override **DOCROOT**, **PHPUSER**, and **PHPGROUP** at build time.
They default to:
* DOCROOT=/var/www
* PHPUSER=root
* PHPGROUP=apache

**Requires**: [rutorrent](rutorrent)
- - - -

For configuration help, you can visit:
https://github.com/Novik/ruTorrent/wiki/PluginThrottle
