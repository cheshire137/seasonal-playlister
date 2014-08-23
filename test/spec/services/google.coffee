'use strict'

describe 'Service: google', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  google = {}
  beforeEach inject (_google_) ->
    google = _google_

  it 'should do something', ->
    expect(!!google).toBe true
