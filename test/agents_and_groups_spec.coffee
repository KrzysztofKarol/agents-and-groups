###
Dependencies
###
assert = require 'assert'
request = require 'request'
_ = require 'underscore'

auth = require './../auth'
errors = require './../lib/errors'

###
Configuration
###
base = 'http://localhost'
port = 3000
endpoint = '/agents_and_groups'
url = "#{base}:#{port}#{endpoint}"

# Extend auth object with invalid data
auth = _.extend(auth, {
  invalidLogin: 'Invalid Login',
  invalidApiKey: 'invalidapikey'
})

###
Run server
###
#app = require '../app'
#app.listen port
#nodemon server.coffee

###
Tests
###

describe "Server GET #{endpoint}", ->
  describe "when requested without HTTP Basic Auth", ->
    it "should respond with code #{errors.basicAuth.code}", (done) ->
      request.get url, (err, res, body) ->
        assert.equal(res.statusCode, errors.basicAuth.code)
        done()
    it "should respond with error message '#{errors.basicAuth.message}'", (done) ->
      request.get url, (err, res, body) ->
        assert.equal(body, errors.basicAuth.message)
        done()

  describe "when requested with invalid HTTP Basic Auth", ->
    it " (invalid login) should respond with code #{errors.invalidLogin.code}", (done) ->
      request.get url,
      {
        'auth': {
          'user': auth.invalidLogin,
          'pass': 'does not matter'
        }
      },
      (err, res, body) ->
        assert.equal(res.statusCode, errors.invalidLogin.code)
        done()
    it " (invalid login) should respond with message '#{errors.invalidLogin.message}'", (done) ->
      request.get url,
        {
          'auth': {
            'user': auth.invalidLogin,
            'pass': 'does not matter'
          }
        },
        (err, res, body) ->
          assert.equal(body, errors.invalidLogin.message)
          done()

    it " (invalid API_KEY) should respond with code #{errors.invalidApiKey.code}", (done) ->
      request.get url,
        {
          'auth': {
            'user': auth.login,
            'pass': auth.invalidApiKey
          }
        },
        (err, res, body) ->
          assert.equal(res.statusCode, errors.invalidApiKey.code)
          done()
    it " (invalid API_KEY) should respond with message '#{errors.invalidApiKey.message}'", (done) ->
      request.get url,
        {
          'auth': {
            'user': auth.login,
            'pass': auth.invalidApiKey
          }
        },
        (err, res, body) ->
          assert.equal(body, errors.invalidApiKey.message)
          done()