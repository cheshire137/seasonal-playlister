'use strict'

describe 'Service: spotifyPlaylist', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  spotifyPlaylist = {}
  beforeEach inject (_spotifyPlaylist_) ->
    spotifyPlaylist = _spotifyPlaylist_

  it 'should do something', ->
    expect(!!spotifyPlaylist).toBe true
