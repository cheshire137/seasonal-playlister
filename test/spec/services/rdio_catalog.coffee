'use strict'

describe 'Service: RdioCatalogSvc', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  RdioCatalogSvc = {}
  beforeEach inject (_rdioCatalog_) ->
    RdioCatalogSvc = _rdioCatalog_

  it 'should do something', ->
    expect(!!RdioCatalogSvc).toBe true
