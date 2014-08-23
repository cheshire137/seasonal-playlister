'use strict'

describe 'Service: GoogleAuthSvc', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  GoogleAuthSvc = {}
  beforeEach inject (_google_) ->
    GoogleAuthSvc = _google_

  it 'should do something', ->
    expect(!!GoogleAuthSvc).toBe true
