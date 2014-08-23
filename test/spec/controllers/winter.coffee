'use strict'

describe 'Controller: WinterCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  WinterCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    WinterCtrl = $controller 'WinterCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
