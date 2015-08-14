Roundcube Webmail is a browser-based multilingual IMAP client with an application-like user interface. It provides full functionality you expect from an email client, including MIME support, address book, folder management, message searching and spell checking. Roundcube Webmail is written in PHP and requires the MySQL, PostgreSQL or SQLite database. With its plugin API it is easily extendable and the user interface is fully customizable using skins which are pure XHTML and CSS 2.  

- - - -  
The code is mainly written in PHP and is designed to run on a webserver. It includes other open-source classes/libraries from [PEAR][pear], an IMAP library derived from [IlohaMail][iloha] the [TinyMCE][tinymce] rich text editor, [Googiespell][googiespell] library for spell checking or the [WASHTML][washtml] sanitizer by Frederic Motte.  

The current default skin uses icons designed by Stephen Horlander and [Kevin
Gerich][kmgerich] for Mozilla.org.  

You can override **DOCROOT**, **PHPUSER**, and **PHPGROUP** at build time.
They default to **DOCROOT=/var/www/webapps**, **PHPUSER=root**, **PHPGROUP=apache**.

- - - -  
For configuration help, you can visit:  
http://trac.roundcube.net/wiki/Howto_Install
