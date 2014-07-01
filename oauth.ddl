--
-- https://github.com/dsquier/oauth2-server-php-mysql
--
-- DDL to create MySQL oauth database and tables for PDO storage
-- support of https://github.com/bshaffer/oauth2-server-php.
--

--
-- Drop any old backups and create a new backup of tables to be created
--
DROP DATABASE IF EXISTS oauth_backup;
CREATE DATABASE oauth_backup;
USE oauth_backup;

CREATE TABLE oauth_access_tokens AS SELECT * FROM oauth.oauth_access_tokens;
CREATE TABLE oauth_authorization_codes AS SELECT * FROM oauth.oauth_authorization_codes;
CREATE TABLE oauth_clients AS SELECT * FROM oauth.oauth_clients;
CREATE TABLE oauth_jwt AS SELECT * FROM oauth.oauth_jwt;
CREATE TABLE oauth_public_keys AS SELECT * FROM oauth.oauth_public_keys;
CREATE TABLE oauth_refresh_tokens AS SELECT * FROM oauth.oauth_refresh_tokens;
CREATE TABLE oauth_scopes AS SELECT * FROM oauth.oauth_scopes;
CREATE TABLE oauth_users AS SELECT * FROM oauth.oauth_users;

--
-- Create oauth database and tables
--
DROP DATABASE IF EXISTS oauth;
CREATE DATABASE oauth;
USE oauth;

CREATE TABLE oauth_access_tokens (
  access_token         VARCHAR(40)    NOT NULL,
  client_id            VARCHAR(80),
  user_id              INT UNSIGNED,
  expires              TIMESTAMP      NOT NULL,
  scope                VARCHAR(4000),
  PRIMARY KEY (access_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE oauth_authorization_codes (
  authorization_code   VARCHAR(40)    NOT NULL,
  client_id            VARCHAR(80),
  user_id              INT UNSIGNED,
  redirect_uri         VARCHAR(2000)  NOT NULL,
  expires              TIMESTAMP      NOT NULL,
  scope                VARCHAR(4000),
  id_token             VARCHAR(80),
  PRIMARY KEY (authorization_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE oauth_clients (
  client_id            VARCHAR(80)   NOT NULL COMMENT 'Unique client identifier',
  client_secret        VARCHAR(80)   NOT NULL COMMENT 'Client secret',
  redirect_uri         VARCHAR(2000)          COMMENT 'Redirect URI used for Authorization Grant',
  grant_types          VARCHAR(80)            COMMENT 'Space-delimited list of grant types permitted, null = all',
  scope                VARCHAR(4000)          COMMENT 'Space-delimited list of approved scopes',
  user_id              INT UNSIGNED           COMMENT 'FK to oauth_users.user_id',
  public_key           VARCHAR(2000)          COMMENT 'Public key for encryption',
  PRIMARY KEY (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE oauth_jwt (
  client_id            VARCHAR(80),
  subject              VARCHAR(80),
  public_key           VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE oauth_public_keys (
  client_id            VARCHAR(80),
  public_key           VARCHAR(2000),
  private_key          VARCHAR(2000),
  encryption_algorithm VARCHAR(100) DEFAULT "RS256"
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE oauth_refresh_tokens (
  refresh_token        VARCHAR(40)    NOT NULL,
  client_id            VARCHAR(80),
  user_id              INT UNSIGNED,
  expires              TIMESTAMP      NOT NULL,
  scope                VARCHAR(4000),
  PRIMARY KEY (refresh_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE oauth_scopes (
  scope                VARCHAR(80)    NOT NULL,
  is_default           BOOLEAN,
  PRIMARY KEY (scope)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE oauth_users (
  user_id              INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  username             VARCHAR(80),
  password             VARCHAR(80),
  first_name           VARCHAR(80),
  last_name            VARCHAR(80),
  scope                VARCHAR(4000),
  email                VARCHAR(2000),
  email_verified       BOOLEAN,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SHOW TABLES;
