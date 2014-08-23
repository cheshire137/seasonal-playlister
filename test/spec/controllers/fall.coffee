'use strict'

describe 'Controller: FallCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  FallCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FallCtrl = $controller 'FallCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
