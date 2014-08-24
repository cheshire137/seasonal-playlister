'use strict'

describe 'Service: trackCleanup', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  trackCleanup = {}
  beforeEach inject (_trackCleanup_) ->
    trackCleanup = _trackCleanup_

  it 'should do something', ->
    expect(!!trackCleanup).toBe true
