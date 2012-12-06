--
-- oauth2-server-php-DDL
--
-- DDL to create MySQL database, user, and tables for PDO storage
-- support of https://github.com/bshaffer/oauth2-server-php.
--

CREATE USER 'oauth'@'localhost' IDENTIFIED BY 'oauth';
DROP DATABASE IF EXISTS oauth;
CREATE DATABASE oauth;
GRANT ALL PRIVILEGES ON oauth.* TO oauth@'%' IDENTIFIED BY 'oauth';

USE oauth;

DROP TABLE IF EXISTS oauth_clients;
CREATE TABLE oauth_clients (
  client_id           VARCHAR(80)    NOT NULL,
  client_secret       VARCHAR(80)    NOT NULL,
  redirect_uri        VARCHAR(2000)  NOT NULL,
  PRIMARY KEY (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS oauth_access_tokens;
CREATE TABLE oauth_access_tokens (
  access_token        VARCHAR(40)    NOT NULL,
  client_id           VARCHAR(80)    NOT NULL,
  user_id             INT UNSIGNED,
  expires             TIMESTAMP      NOT NULL,
  scope               VARCHAR(2000),
  PRIMARY KEY (access_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS oauth_authorization_codes;
CREATE TABLE oauth_authorization_codes (
  authorization_code  VARCHAR(40)    NOT NULL,
  client_id           VARCHAR(80)    NOT NULL,
  user_id             INT UNSIGNED,
  redirect_uri        VARCHAR(2000)  NOT NULL,
  expires             TIMESTAMP      NOT NULL,
  scope               VARCHAR(2000),
  PRIMARY KEY (authorization_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS oauth_refresh_tokens;
CREATE TABLE oauth_refresh_tokens (
  refresh_token       VARCHAR(40)    NOT NULL,
  client_id           VARCHAR(40)    NOT NULL,
  user_id             INT UNSIGNED,
  expires             TIMESTAMP      NOT NULL,
  scope               VARCHAR(2000),
  PRIMARY KEY (refresh_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS oauth_users;
CREATE TABLE oauth_users (
  user_id             INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  username            VARCHAR(80),
  password            VARCHAR(80),
  first_name          VARCHAR(80),
  last_name           VARCHAR(80),
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

