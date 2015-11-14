###
Module dependencies
###
express = require 'express'
app = express()
basicAuthValidator = require './lib/basicAuthValidator'
LiveChat = require './lib/LiveChat'

# HTTP Basic Auth Validation
app.use(basicAuthValidator)

###
ROUTE: AGENTS AND GROUPS '/agents_and_groups' (GET)
###
app.get '/agents_and_groups', (req, res) ->
  liveChat = new LiveChat req.agentsAndGroups.login, req.agentsAndGroups.apiKey
  liveChat.get(['agents', 'groups'], (err, body) ->
    res.json {error: err, body: body}
  )

###
Export express instance
###
module.exports = app