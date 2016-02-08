INSERT INTO oauth_clients (client_id, client_secret, redirect_uri, grant_types, scope, user_id)
VALUES
    ('password-credentials', 'password1', '/authorize', 'password refresh_token', 'trusted-scope'),
    ('client-credentials', 'password2', '/authorize', 'client_credentials refresh_token', NULL);

INSERT INTO oauth_scopes (scope, is_default) VALUES ('trusted-scope', 1);

<?php
/**
 * Implements OAuth Token Checking for iPaid using all acceptable OAuth methods
 *
 * Usage: $app->get('/route', $verifyToken('update'), function() {});
 */
$verifyToken = function ($scopeRequired = null) {
    return function() use ($scopeRequired) {
        $dbh = get_storage('oauth');
        $storage = new OAuth2\Storage\Pdo($dbh);
        $server = new OAuth2\Server($storage);
        $server->setScopeUtil(new OAuth2\Scope($storage));
        $request = OAuth2\Request::createFromGlobals();

        // Initialze to prevent errors when no access_token submitted
        $access_token = null;

        // Check if token was sent in POST
        if (isset($request->request['access_token'])) {
            $access_token = $request->request['access_token'];
        }

        // Check if token was sent in GET
        if (isset($request->query['access_token'])) {
            $access_token = $request->query['access_token'];
        }

        // Receives a request object for a resource request, finds the token if
        // it exists, and returns a boolean for whether the incoming request is valid
        if (!$server->verifyResourceRequest($request, new OAuth2\Response(), $scopeRequired)) {
            $server->getResponse()->send();
            exit;
        } else {
            // Takes a token string and returns the token data or null if the token is invalid
            $token = $server->getAccessTokenData($request, new OAuth2\Response());
        }
    };
};


// Should work for both grant types
$app->get('/client-credentials', $verifyToken(),
    function () {
        echo "/client-credentials authorized!"
    });

// Should only work for Resource Owner Password Credentials grant type
$app->get('/password-credentials', $verifyToken('trusted-scope'),
    function () {
        echo "/password-credentials authorized!"
    });
