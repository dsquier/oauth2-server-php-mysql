oauth2-server-php-mysql
=======================
DDL to create MySQL `oauth` user, database, and tables for PDO storage
support of https://github.com/bshaffer/oauth2-server-php.

Deployment
----------
Log into MySQL as root and type:

	mysql> source oauth.ddl

This will create a new `oauth` user, database, and tables. Any existing tables will be backed up to `oauth_backup`. To load the test data used for Travis CI:

    mysql> source oauth.dml

Notes
-----
* Tracks **develop** branch of https://github.com/bshaffer/oauth2-server-php.
* Storage for *Global* and *Client* `supported_scopes` and `default_scope`.
* Where possible, column constraints based on current library implementation
(i.e., token length of 40 characters for authorization_code, access_token, refresh_token.)
* You should change the `oauth` user password.


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
**oauth_globals**
```
+-------------+---------------+------+-----+---------+-------+
| Field       | Type          | Null | Key | Default | Extra |
+-------------+---------------+------+-----+---------+-------+
| oauth_key   | varchar(80)   | NO   | PRI | NULL    |       |
| oauth_value | varchar(2000) | YES  |     | NULL    |       |
+-------------+---------------+------+-----+---------+-------+
```