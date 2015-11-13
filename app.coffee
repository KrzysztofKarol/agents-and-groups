###
Module dependencies
###
express = require 'express'
app = express()
basicAuthValidator = require './lib/basicAuthValidator'

# HTTP Basic Auth Validation
app.use(basicAuthValidator)

###
ROUTE: AGENTS AND GROUPS '/agents_and_groups' (GET)
###
app.get '/agents_and_groups', (req, res) ->
  res.send('Hello world!')

module.exports = app