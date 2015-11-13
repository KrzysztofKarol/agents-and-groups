assert = require 'assert'
request = require 'request'

base = 'http://localhost'
port = 3000
endpoint = '/agents_and_groups'
url = "#{base}:#{port}#{endpoint}"

describe "Server GET #{endpoint}", ->
  app = require '../app'
  beforeEach ->
    app.listen port
  afterEach ->
    app.close

  it 'should respond with code 200', (done) ->
    request.get url, (err, res, body) ->
      assert.equal(res.statusCode, 200)
      done()