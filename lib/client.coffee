OAuth = require 'oauth'
superagent = require 'superagent'

module.exports = (clientId, secret, baseSite, cb) ->
  OAuth2 = OAuth.OAuth2

  oauth2 = new OAuth2 clientId, secret, baseSite, null, '/oauth2/token', null

  oauth2.getOAuthAccessToken '', {grant_type: 'client_credentials'},
    (err, access_token) ->
      return cb err if err

      request = (method, action, data, cb) ->
        superagent[method]("#{baseSite}/api/#{action}").send(data)
        .set('Authorization', 'Bearer ' + access_token).end (err, res) ->
          return cb err if err
          data = JSON.parse res.text
          if data.success is false
            return cb data.message
          cb null, data


      cb null,
        user:
          create: (data, cb) ->
            request 'post', 'user/create', data, cb

          authenticate: (data, cb) ->
            request 'post', 'user/authenticate', data, cb

          getToken: (data, cb) ->
            request 'post', '/user/getToken', data, cb

        orgchart:
          createNode: (data, cb) ->
            request 'post', 'orgchart/createNode', data, cb

          assignUsersToNode: (data, cb) ->
            request 'post', 'orgchart/assignUsersToNode', data, cb

        course:
          courses: (data, cb) ->
            request 'post', 'course/courses', data, cb

          addUserSubscription: (data, cb) ->
            request 'post', 'course/addUserSubscription', data, cb
