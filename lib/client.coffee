OAuth = require 'oauth'

module.exports = (clientId, secret, domain, cb) ->
  console.log {clientId, secret, domain, cb}
  OAuth2 = OAuth.OAuth2
  oauth2 = new OAuth2 clientId, secret, "http://#{domain}/api", null, 'oauth2/token', null

  oauth2.getOAuthAccessToken '', {grant_type: 'client_credentials'},
    (err, access_token, refresh_token, results) ->
      return cb err.message if err

      console.log {err, access_token, refresh_token, results}
      console.log 'bearer: ', access_token