auth = require 'basic-auth'
errors = require './errors'

# How about .berlin?
emailPattern = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
apiKeyPattern = /^[0-9a-f]{32}$/

module.exports = (request, response, next) ->
  credentials = auth request
  console.log(credentials)

  #  Basic auth, both login and API_KEY not provided
  if not credentials
    response.status(errors.basicAuth.code).end errors.basicAuth.message
  else
    login = credentials.name
    apiKey = credentials.pass
    if not login.match emailPattern # Could be optimized
      response.status(errors.invalidLogin.code).end errors.invalidLogin.message
    else if not apiKey.match apiKeyPattern
      response.status(errors.invalidApiKey.code).end errors.invalidApiKey.message
    else
      request.agentsAndGroups || (request.agentsAndGroups = {})
      request.agentsAndGroups.login = login
      request.agentsAndGroups.apiKey = apiKey
      next()