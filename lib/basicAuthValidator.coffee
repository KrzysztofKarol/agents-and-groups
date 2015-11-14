auth = require 'basic-auth'
errors = require './errors'

# TODO: How about .berlin?
emailPattern = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
apiKeyPattern = /^[0-9a-f]{32}$/

# TODO: Refactor. Validation middleware looks very bad but now I have no idea what to do
module.exports = (req, res, next) ->
  credentials = auth req

  #  Basic auth, both login and API_KEY not provided
  if not credentials
    res.status(errors.basicAuth.code).end errors.basicAuth.message
  else
    login = credentials.name
    apiKey = credentials.pass
    if not login.match emailPattern
      res.status(errors.invalidLogin.code).end errors.invalidLogin.message
    else if not apiKey.match apiKeyPattern
      res.status(errors.invalidApiKey.code).end errors.invalidApiKey.message
    else
      req.agentsAndGroups || (req.agentsAndGroups = {})
      req.agentsAndGroups.login = login
      req.agentsAndGroups.apiKey = apiKey
      next()