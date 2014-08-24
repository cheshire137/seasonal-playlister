'use strict'

describe 'Service: RdioPlaylistSvc', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  RdioPlaylistSvc = {}
  beforeEach inject (_rdioPlaylist_) ->
    RdioPlaylistSvc = _rdioPlaylist_

  it 'should do something', ->
    expect(!!RdioPlaylistSvc).toBe true
