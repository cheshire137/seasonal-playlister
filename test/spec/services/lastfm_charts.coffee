'use strict'

describe 'Service: lastfmCharts', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  lastfmCharts = {}
  beforeEach inject (_lastfmCharts_) ->
    lastfmCharts = _lastfmCharts_

  it 'should do something', ->
    expect(!!lastfmCharts).toBe true
