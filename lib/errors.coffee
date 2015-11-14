module.exports =
  basicAuth:
    code: 401
    message: 'You must provide login and API_KEY via HTTP Basic Auth'
  invalidLogin:
    code: 401
    message: 'HTTP Basic Auth: Invalid login'
  invalidApiKey:
    code: 401
    message: 'HTTP Basic Auth: Invalid API_KEY'