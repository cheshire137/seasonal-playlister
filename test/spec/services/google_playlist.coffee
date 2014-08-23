'use strict'

describe 'Service: googlePlaylist', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  googlePlaylist = {}
  beforeEach inject (_googlePlaylist_) ->
    googlePlaylist = _googlePlaylist_

  it 'should do something', ->
    expect(!!googlePlaylist).toBe true
