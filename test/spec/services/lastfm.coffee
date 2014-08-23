'use strict'

describe 'Service: lastfm', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  lastfm = {}
  beforeEach inject (_lastfm_) ->
    lastfm = _lastfm_

  it 'should do something', ->
    expect(!!lastfm).toBe true
