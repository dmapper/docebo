OAuth = require 'oauth'
superagent = require 'superagent'



module.exports = (clientId, secret, baseSite, cb) ->
  OAuth2 = OAuth.OAuth2

  request = (action, data, cb) ->
    superagent.post("#{baseUrl}/api/#{action}").send(data).end (err, res) ->
      return cb err if err
      cb null, JSON.parse res

  oauth2 = new OAuth2 clientId, secret, baseSite, null, 'oauth2/token', null

  oauth2.getOAuthAccessToken '', {grant_type: 'client_credentials'},
    (err, access_token, refresh_token, results) ->
      return cb err if err

      cb null, {
        user: {
          create: (data, cb) ->
            data.access_token = access_token
            request 'user/create', data, cb
        }
      }