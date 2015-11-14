async = require 'async'
request = require 'request'
_ = require 'underscore'
#util = require 'util'

class LiveChat
  # I know fat arrow but I want apiRequest method to be private
  # TODO: Think about better solution. http://evanhahn.com/private-members-in-coffeescript/

  that = null

  constructor: (@login, @apiKey) ->
    that = @

  get: (endpoints, cb) ->
    async.map endpoints, _apiRequest, (err, data) ->
# Convert to object {endpoint1: body1, endpoint2: body2}
      data = _.object(_.map(data, _.values))
      cb(err, data)

  # Private
  _base = 'https://api.livechatinc.com'
  _apiRequest = (endpoint, cb) ->
    url = "#{_base}/#{endpoint}"
    options =
      headers:
        'X-API-Version': 2
      auth:
        user: that.login
        pass: that.apiKey


    # Great prettify: console.log(util.inspect(res, { colors: true, depth: null }));
    # TODO: Think about better error handler
    request.get url, options, (err, res, body) ->
# If LiveChat responds with err
      if body.match(/Cannot GET/) then return cb body

      body = JSON.parse body
      # If LiveChat returns (auth) error
      if _.has body, 'error' then return cb body.error

      # Else return body
      cb null, {endpoint: endpoint, body: body}


module.exports = LiveChat