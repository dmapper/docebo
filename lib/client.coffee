OAuth = require 'oauth'
superagent = require 'superagent'



module.exports = (clientId, secret, baseSite, cb) ->
  OAuth2 = OAuth.OAuth2

  oauth2 = new OAuth2 clientId, secret, baseSite, null, '/oauth2/token', null

  oauth2.getOAuthAccessToken '', {grant_type: 'client_credentials'},
    (err, access_token) ->
      return cb err if err

      request = (action, data, cb) ->
        superagent.post("#{baseUrl}/api/#{action}").send(data)
        .set('Authorization', access_token).end (err, res) ->
          console.log {err, res}
          return cb err if err
          cb null, JSON.parse res

      cb null, {
        user: {
          create: (data, cb) ->
            request 'user/create', data, cb
        }
      }