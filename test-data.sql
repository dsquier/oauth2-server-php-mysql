--
-- https://github.com/dsquier/oauth2-server-php-mysql
--
-- DML to test MySQL 'oauth' database and tables for PDO storage
-- support of https://github.com/bshaffer/oauth2-server-php.
--

-- Scopes
INSERT INTO oauth_scopes (scope) VALUES ('supportedscope1');
INSERT INTO oauth_scopes (scope) VALUES ('supportedscope2');
INSERT INTO oauth_scopes (scope) VALUES ('supportedscope3');
INSERT INTO oauth_scopes (scope) VALUES ('supportedscope4');
INSERT INTO oauth_scopes (scope) VALUES ('clientscope1');
INSERT INTO oauth_scopes (scope) VALUES ('clientscope2');
INSERT INTO oauth_scopes (scope) VALUES ('clientscope3');
INSERT INTO oauth_scopes (scope, is_default) VALUES ('defaultscope1', 1);
INSERT INTO oauth_scopes (scope, is_default) VALUES ('defaultscope2', 1);
SELECT * FROM oauth_scopes;

-- Clients
INSERT INTO oauth_clients (client_id, client_secret, scope) VALUES ("Test Client ID", "TestSecret", "clientscope1 clientscope2");
INSERT INTO oauth_clients (client_id, client_secret, scope) VALUES ("Test Client ID 2", "TestSecret", "clientscope1 clientscope2 clientscope3");
INSERT INTO oauth_clients (client_id, client_secret, scope) VALUES ("Test Default Scope Client ID", "TestSecret", "clientscope1 clientscope2");
INSERT INTO oauth_clients (client_id, client_secret, grant_types) VALUES ("oauth_test_client", "testpass", "implicit password");
SELECT * FROM oauth_clients;

-- Misc
INSERT INTO oauth_access_tokens (access_token, client_id) VALUES ("testtoken", "Some Client");
SELECT * FROM oauth_access_tokens;

INSERT INTO oauth_authorization_codes (authorization_code, client_id) VALUES ("testcode", "Some Client");
SELECT * FROM oauth_authorization_codes;

INSERT INTO oauth_users (username, password) VALUES ("testuser", "password");
SELECT * FROM oauth_users;

-- Ensure path to rsa keys is valid, placeholder used here
INSERT INTO oauth_public_keys (client_id, public_key, private_key, encryption_algorithm) VALUES (NULL, "/home/keys/id_rsa.pub", "/home/keys/id_rsa", "RS256");
INSERT INTO oauth_public_keys (client_id, public_key, private_key, encryption_algorithm) VALUES ("ClientID_One", "client_1_public", "client_1_private", "RS256");
INSERT INTO oauth_public_keys (client_id, public_key, private_key, encryption_algorithm) VALUES ("ClientID_Two", "client_2_public", "client_2_private", "RS256");
SELECT * FROM oauth_public_keys;
