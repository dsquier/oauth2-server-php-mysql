oauth2-server-php-mysql
=======================
DDL to create MySQL oauth user and database for PDO storage support of https://github.com/bshaffer/oauth2-server-php.

## Deployment

### Create database

    # mysql -uroot -p -f < ./oauth.ddl

If there is an existing `oauth` database, a copy will be saved to `oauth_backup` prior to dropping and creating a new one. If there is no existing `oauth` database to backup, MySQL will return the error `Table <NAME> doesn't exist` for each table. These can be ignored.

### Load test data

    mysql> source test-data.sql

Test data is used to perform unit testing of the PDO interface and also to provide an example implementation for the different grant types. This file should not be run for production deployments.

## If Implementing Scopes..

### Work-around for pre-1.8 versions of the library

A bug that affects the behavior of scopes was [fixed](https://github.com/bshaffer/oauth2-server-php/commit/4ccfab7d490d81e0c3e610f4309acb64976e626e) in [version 1.8](https://github.com/bshaffer/oauth2-server-php/tree/v1.8.0) of the library. If you are on a version prior to 1.8, you may be affected if your application:

* Uses scopes
* AND implements the Resource Owner Password Credential grant type
* AND implements another grant type (such as Client Credentials)

A `NULL` value in `oauth_clients.scope` will cause a token to be granted with ALL default scopes found in `oauth_scopes`. This opens up the possibility for a less-permissioned token granted from an unauthenticated Client Credentials request could be used to access resources that otherwise would require a username and password.

To fix this, insert a "dummy" value for `oauth_clients.scope`:

    mysql> INSERT INTO oauth_clients (client_id, scope) VALUES (YOUR_CLIENT_ID, "dummy-value");

This step is **not** necessary if you are using version 1.8 or higher of the library.

### Using Multiple Scopes

* A token must have ALL scopes listed on an endpoint to gain access to it.
* If any single scope is missing, access will be denied.

## Tables
------
### oauth_access_tokens
```
+--------------+---------------+------+-----+---------+-------+
| Field        | Type          | Null | Key | Default | Extra |
+--------------+---------------+------+-----+---------+-------+
| access_token | varchar(40)   | NO   | PRI | NULL    |       |
| client_id    | varchar(80)   | YES  |     | NULL    |       |
| user_id      | varchar(80)   | YES  |     | NULL    |       |
| expires      | timestamp     | NO   |     | NULL    |       |
| scope        | varchar(4000) | YES  |     | NULL    |       |
+--------------+---------------+------+-----+---------+-------+
```
### oauth_authorization_codes
```
+--------------------+---------------+------+-----+---------+-------+
| Field              | Type          | Null | Key | Default | Extra |
+--------------------+---------------+------+-----+---------+-------+
| authorization_code | varchar(40)   | NO   | PRI | NULL    |       |
| client_id          | varchar(80)   | YES  |     | NULL    |       |
| user_id            | varchar(80)   | YES  |     | NULL    |       |
| redirect_uri       | varchar(2000) | NO   |     | NULL    |       |
| expires            | timestamp     | NO   |     | NULL    |       |
| scope              | varchar(4000) | YES  |     | NULL    |       |
| id_token           | varchar(1000) | YES  |     | NULL    |       |
+--------------------+---------------+------+-----+---------+-------+
```
### oauth_clients
```
+---------------+---------------+------+-----+---------+-------+
| Field         | Type          | Null | Key | Default | Extra |
+---------------+---------------+------+-----+---------+-------+
| client_id     | varchar(80)   | NO   | PRI | NULL    |       |
| client_secret | varchar(80)   | YES  |     | NULL    |       |
| redirect_uri  | varchar(2000) | YES  |     | NULL    |       |
| grant_types   | varchar(80)   | YES  |     | NULL    |       |
| scope         | varchar(4000) | YES  |     | NULL    |       |
| user_id       | varchar(80)   | YES  |     | NULL    |       |
+---------------+---------------+------+-----+---------+-------+
```
### oauth_jti
```
+----------+---------------+------+-----+---------+-------+
| Field    | Type          | Null | Key | Default | Extra |
+----------+---------------+------+-----+---------+-------+
| issuer   | varchar(80)   | NO   |     | NULL    |       |
| subject  | varchar(80)   | YES  |     | NULL    |       |
| audience | varchar(80)   | YES  |     | NULL    |       |
| expires  | timestamp     | NO   |     | NULL    |       |
| jti      | varchar(2000) | NO   |     | NULL    |       |
+----------+---------------+------+-----+---------+-------+
```
### oauth_jwt
```
+------------+---------------+------+-----+---------+-------+
| Field      | Type          | Null | Key | Default | Extra |
+------------+---------------+------+-----+---------+-------+
| client_id  | varchar(80)   | NO   |     | NULL    |       |
| subject    | varchar(80)   | YES  |     | NULL    |       |
| public_key | varchar(2000) | NO   |     | NULL    |       |
+------------+---------------+------+-----+---------+-------+
```
### oauth_public_keys
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
### oauth_refresh_tokens
```
+---------------+------------------+------+-----+-------------------+-----------------------------+
| Field         | Type             | Null | Key | Default           | Extra                       |
+---------------+------------------+------+-----+-------------------+-----------------------------+
| refresh_token | varchar(40)      | NO   | PRI | NULL              |                             |
| client_id     | varchar(80)      | YES  |     | NULL              |                             |
| user_id       | varchar(80)      | YES  |     | NULL              |                             |
| expires       | timestamp        | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| scope         | varchar(4000)    | YES  |     | NULL              |                             |
+---------------+------------------+------+-----+-------------------+-----------------------------+
```
### oauth_scopes
```
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| scope      | varchar(80) | NO   | PRI | NULL    |       |
| is_default | tinyint(1)  | YES  |     | NULL    |       |
+------------+-------------+------+-----+---------+-------+
```
### oauth_users
```
+----------------+------------------+------+-----+---------+----------------+
| Field          | Type             | Null | Key | Default | Extra          |
+----------------+------------------+------+-----+---------+----------------+
| username       | varchar(80)      | YES  |     | NULL    |                |
| password       | varchar(80)      | YES  |     | NULL    |                |
| first_name     | varchar(80)      | YES  |     | NULL    |                |
| last_name      | varchar(80)      | YES  |     | NULL    |                |
| email          | varchar(2000)    | YES  |     | NULL    |                |
| email_verified | tinyint(1)       | YES  |     | NULL    |                |
| scope          | varchar(4000)    | YES  |     | NULL    |                |
+----------------+------------------+------+-----+---------+----------------+
```
