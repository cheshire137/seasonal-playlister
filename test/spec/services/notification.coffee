'use strict'

describe 'Service: notification', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  notification = {}
  beforeEach inject (_notification_) ->
    notification = _notification_

  it 'should do something', ->
    expect(!!notification).toBe true
