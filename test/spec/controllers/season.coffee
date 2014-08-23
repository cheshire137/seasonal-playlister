'use strict'

describe 'Controller: SeasonCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  SeasonCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SeasonCtrl = $controller 'SeasonCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
