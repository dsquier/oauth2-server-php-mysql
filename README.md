oauth2-server-php-mysql
=======================
DDL to create MySQL database, user, and tables for PDO storage
support of https://github.com/bshaffer/oauth2-server-php.

Deployment
----------
To deploy, log into MySQL as root and type:

	mysql> source oauth.ddl

This script creates a database called "oauth" and a user with a name
and password of "oauth". Assuming PHP is on the same host as the MySQL 
database, the PDO connection string will be:

	$c = new PDO('mysql:dbname=oauth;host=localhost', 'oauth', 'oauth');

Notes
-----
* This script DROPS all objects before creation, so take care when
running on an existing 'oauth' database. 
* You should change the database password for the 'oauth' user.
* DML is included in oauth.dml to populate test data used by library.
* Where possible, column constraints based on current library
implementation (i.e., token length of 40 characters for authorization_code, 
access_token, refresh_token.)
