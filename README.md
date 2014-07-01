oauth2-server-php-mysql
=======================
DDL to create MySQL oauth user and database for PDO storage
support of https://github.com/bshaffer/oauth2-server-php.

Deployment
----------
1) Create a new oauth user and database:

    mysql> source oauth.ddl

2) Load test data:

    mysql> source oauth.dml

Notes
-----
* Tracks current production branch of https://github.com/bshaffer/oauth2-server-php.
* Where possible, column constraints based on current library implementation
(i.e., token length of 40 characters for authorization_code, access_token, refresh_token.)
* You should change the **oauth** user password.
* Any existing tables will be saved to **oauth_backup**

Tables
------
**oauth_access_tokens**
```
+--------------+------------------+------+-----+-------------------+-----------------------------+
| Field        | Type             | Null | Key | Default           | Extra                       |
+--------------+------------------+------+-----+-------------------+-----------------------------+
| access_token | varchar(40)      | NO   | PRI | NULL              |                             |
| client_id    | varchar(80)      | YES  |     | NULL              |                             |
| user_id      | int(10) unsigned | YES  |     | NULL              |                             |
| expires      | timestamp        | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| scope        | varchar(4000)    | YES  |     | NULL              |                             |
+--------------+------------------+------+-----+-------------------+-----------------------------+
```
**oauth_authorization_codes**
```
+--------------------+------------------+------+-----+-------------------+-----------------------------+
| Field              | Type             | Null | Key | Default           | Extra                       |
+--------------------+------------------+------+-----+-------------------+-----------------------------+
| authorization_code | varchar(40)      | NO   | PRI | NULL              |                             |
| client_id          | varchar(80)      | YES  |     | NULL              |                             |
| user_id            | int(10) unsigned | YES  |     | NULL              |                             |
| redirect_uri       | varchar(2000)    | NO   |     | NULL              |                             |
| expires            | timestamp        | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| scope              | varchar(4000)    | YES  |     | NULL              |                             |
| id_token           | varchar(80)      | YES  |     | NULL              |                             |
+--------------------+------------------+------+-----+-------------------+-----------------------------+
```
**oauth_clients**
```
+---------------+------------------+------+-----+---------+-------+
| Field         | Type             | Null | Key | Default | Extra |
+---------------+------------------+------+-----+---------+-------+
| client_id     | varchar(80)      | NO   | PRI | NULL    |       |
| client_secret | varchar(80)      | NO   |     | NULL    |       |
| redirect_uri  | varchar(2000)    | YES  |     | NULL    |       |
| grant_types   | varchar(80)      | YES  |     | NULL    |       |
| scope         | varchar(4000)    | YES  |     | NULL    |       |
| user_id       | int(10) unsigned | YES  |     | NULL    |       |
| public_key    | varchar(2000)    | YES  |     | NULL    |       |
+---------------+------------------+------+-----+---------+-------+
```
**oauth_jwt**
```
+------------+---------------+------+-----+---------+-------+
| Field      | Type          | Null | Key | Default | Extra |
+------------+---------------+------+-----+---------+-------+
| client_id  | varchar(80)   | YES  |     | NULL    |       |
| subject    | varchar(80)   | YES  |     | NULL    |       |
| public_key | varchar(2000) | YES  |     | NULL    |       |
+------------+---------------+------+-----+---------+-------+
```
**oauth_public_keys**
```
+----------------------+---------------+------+-----+---------+-------+
| Field                | Type          | Null | Key | Default | Extra |
+----------------------+---------------+------+-----+---------+-------+
| client_id            | varchar(80)   | YES  |     | NULL    |       |
| public_key           | varchar(2000) | YES  |     | NULL    |       |
| private_key          | varchar(2000) | YES  |     | NULL    |       |
| encryption_algorithm | varchar(100)  | YES  |     | RS256   |       |
+----------------------+---------------+------+-----+---------+-------+
```
**oauth_refresh_tokens**
```
+---------------+------------------+------+-----+-------------------+-----------------------------+
| Field         | Type             | Null | Key | Default           | Extra                       |
+---------------+------------------+------+-----+-------------------+-----------------------------+
| refresh_token | varchar(40)      | NO   | PRI | NULL              |                             |
| client_id     | varchar(80)      | YES  |     | NULL              |                             |
| user_id       | int(10) unsigned | YES  |     | NULL              |                             |
| expires       | timestamp        | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| scope         | varchar(4000)    | YES  |     | NULL              |                             |
+---------------+------------------+------+-----+-------------------+-----------------------------+
```
**oauth_scopes**
```
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| scope      | varchar(80) | NO   | PRI | NULL    |       |
| is_default | tinyint(1)  | YES  |     | NULL    |       |
+------------+-------------+------+-----+---------+-------+
```
**oauth_users**
```
+----------------+------------------+------+-----+---------+----------------+
| Field          | Type             | Null | Key | Default | Extra          |
+----------------+------------------+------+-----+---------+----------------+
| user_id        | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| username       | varchar(80)      | YES  |     | NULL    |                |
| password       | varchar(80)      | YES  |     | NULL    |                |
| first_name     | varchar(80)      | YES  |     | NULL    |                |
| last_name      | varchar(80)      | YES  |     | NULL    |                |
| scope          | varchar(4000)    | YES  |     | NULL    |                |
| email          | varchar(2000)    | YES  |     | NULL    |                |
| email_verified | tinyint(1)       | YES  |     | NULL    |                |
+----------------+------------------+------+-----+---------+----------------+
```