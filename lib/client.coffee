OAuth = require 'oauth'
superagent = require 'superagent'

module.exports = (clientId, secret, baseSite, cb) ->
  OAuth2 = OAuth.OAuth2

  oauth2 = new OAuth2 clientId, secret, baseSite, null, '/oauth2/token', null

  oauth2.getOAuthAccessToken '', {grant_type: 'client_credentials'},
    (err, access_token) ->
      return cb err if err

      console.log {access_token}

      request = (action, data, cb) ->
        superagent.get("#{baseSite}/api/#{action}").send(data)
        .set('Authorization', access_token).end (err, res) ->
          return cb err if err
          data = JSON.parse res.text
          if data.success is false
            return cb data.message
          cb null, data


      cb null, {
        user: {
          create: (data, cb) ->
            request 'user/create', data, cb
        }
      }