'use strict'

describe 'Service: spotifyCatalog', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  spotifyCatalog = {}
  beforeEach inject (_spotifyCatalog_) ->
    spotifyCatalog = _spotifyCatalog_

  it 'should do something', ->
    expect(!!spotifyCatalog).toBe true
