oauth2-server-php-mysql
=======================
DDL to create MySQL **oauth** database and tables for PDO storage
support of https://github.com/bshaffer/oauth2-server-php.

Deployment
----------
Log into MySQL as root and type:

	mysql> source oauth.ddl

This will backup any tables that exist into `oauth_backup` and create a new `oauth` user, database and tables.

Notes
-----
* You should change the 'oauth' database password.
* DML is included in oauth.dml to populate test data used by library.
* Where possible, column constraints based on current library implementation (i.e., token length of 40 characters for authorization_code, access_token, refresh_token.)
* Supports scope storage with *default* and *supported* scopes per client, and *supported* scopes per user (Note: requires changes to Pdo.php and TokenController.php)

Tables
------
**oauth_access_tokens**
```
+--------------+------------------+------+-----+-------------------+-----------------------------+
| Field        | Type             | Null | Key | Default           | Extra                       |
+--------------+------------------+------+-----+-------------------+-----------------------------+
| access_token | varchar(40)      | NO   | PRI | NULL              |                             |
| client_id    | varchar(80)      | NO   |     | NULL              |                             |
| user_id      | int(10) unsigned | YES  |     | NULL              |                             |
| expires      | timestamp        | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| scope        | varchar(2000)    | YES  |     | NULL              |                             |
+--------------+------------------+------+-----+-------------------+-----------------------------+
```
**oauth_authorization_codes**
```
+--------------------+------------------+------+-----+-------------------+-----------------------------+
| Field              | Type             | Null | Key | Default           | Extra                       |
+--------------------+------------------+------+-----+-------------------+-----------------------------+
| authorization_code | varchar(40)      | NO   | PRI | NULL              |                             |
| client_id          | varchar(80)      | NO   |     | NULL              |                             |
| user_id            | int(10) unsigned | YES  |     | NULL              |                             |
| redirect_uri       | varchar(2000)    | NO   |     | NULL              |                             |
| expires            | timestamp        | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| scope              | varchar(2000)    | YES  |     | NULL              |                             |
+--------------------+------------------+------+-----+-------------------+-----------------------------+
```
**oauth_clients**
```
+------------------+---------------+------+-----+---------+-------+
| Field            | Type          | Null | Key | Default | Extra |
+------------------+---------------+------+-----+---------+-------+
| client_id        | varchar(80)   | NO   | PRI | NULL    |       |
| client_secret    | varchar(80)   | NO   |     | NULL    |       |
| redirect_uri     | varchar(2000) | NO   |     | NULL    |       |
| grant_types      | varchar(80)   | YES  |     | NULL    |       |
| supported_scopes | varchar(2000) | YES  |     | NULL    |       |
| default_scope    | varchar(2000) | YES  |     | NULL    |       |
+------------------+---------------+------+-----+---------+-------+
```
**oauth_jwt**
```
+------------+---------------+------+-----+---------+-------+
| Field      | Type          | Null | Key | Default | Extra |
+------------+---------------+------+-----+---------+-------+
| client_id  | varchar(80)   | NO   | PRI | NULL    |       |
| subject    | varchar(80)   | YES  |     | NULL    |       |
| public_key | varchar(2000) | YES  |     | NULL    |       |
+------------+---------------+------+-----+---------+-------+
```
**oauth_refresh_tokens**
```
+---------------+------------------+------+-----+-------------------+-----------------------------+
| Field         | Type             | Null | Key | Default           | Extra                       |
+---------------+------------------+------+-----+-------------------+-----------------------------+
| refresh_token | varchar(40)      | NO   | PRI | NULL              |                             |
| client_id     | varchar(80)      | NO   |     | NULL              |                             |
| user_id       | int(10) unsigned | YES  |     | NULL              |                             |
| expires       | timestamp        | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| scope         | varchar(2000)    | YES  |     | NULL              |                             |
+---------------+------------------+------+-----+-------------------+-----------------------------+
```
**oauth_users**
```
+------------------+------------------+------+-----+---------+----------------+
| Field            | Type             | Null | Key | Default | Extra          |
+------------------+------------------+------+-----+---------+----------------+
| user_id          | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| username         | varchar(80)      | YES  |     | NULL    |                |
| password         | varchar(80)      | YES  |     | NULL    |                |
| first_name       | varchar(80)      | YES  |     | NULL    |                |
| last_name        | varchar(80)      | YES  |     | NULL    |                |
| supported_scopes | varchar(2000)    | YES  |     | NULL    |                |
+------------------+------------------+------+-----+---------+----------------+
```
