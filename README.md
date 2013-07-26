oauth2-server-php-mysql
=======================
DDL to create MySQL 'oauth' database and tables for PDO storage
support of https://github.com/bshaffer/oauth2-server-php.

Deployment
----------
Log into MySQL as root and type:

	mysql> source oauth.ddl

This will do the following:

* Drop any prior `oauth_backup` database.
* Backup all tables from an existing `oauth` database to `oauth_backup`.
* Drop any prior `oauth` database.
* Create a new `oauth` user, database and tables.

Scope Support
-------------
Scope storage is supported with ability to assign a default scope per client and supported scopes per client and user. Please note this is not currently supported in the oauth2-server-php library and will require updates to `Pdo.php`, `Scope.php`, and `TokenController.php` to implement.

Once implemented, scopes can be defined and enforced at both the client level for all requests and at the user level for Resource Owner Password Credential

Notes
-----
* You should change the 'oauth' database password.
* DML is included in oauth.dml to populate test data used by library.
* Where possible, column constraints based on current library implementation (i.e., token length of 40 characters for authorization_code, access_token, refresh_token.)