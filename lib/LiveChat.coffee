async = require 'async'
request = require 'request'
_ = require 'underscore'
util = require 'util'

class LiveChat
  that = null
  constructor: (@login, @apiKey) ->
# I know fat arrow but I want apiRequest method to be private
#    TODO: Think about better solution. http://evanhahn.com/private-members-in-coffeescript/
    that = @

  get: (endpointsArr, cb) ->
    async.map(endpointsArr, _apiRequest, (err, data) ->
# Convert to object {endpoint1: body1, endpoint2: body2}
      data = _.object(_.map(data, _.values))
      cb(err, data)
    )

  _base = 'https://api.livechatinc.com'
  _apiRequest = (endpoint, cb) ->
    options = {
      headers: {
        'X-API-Version': 2
      },
      auth: {
        user: that.login
        pass: that.apiKey
      }
    }

    request.get("#{_base}/#{endpoint}", options, (err, res, body) ->
#      console.log(util.inspect(res, { colors: true, depth: null }));
      # TODO: Think about better error handler

# If livechat responds with err
      if body.match(/Cannot GET/) then return cb body, null

      body = JSON.parse(body)

      if _.has body, 'error' then return cb body.error, null

      cb null, {endpoint: endpoint, body: body}
    )

module.exports = LiveChat