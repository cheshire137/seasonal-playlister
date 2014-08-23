'use strict'

describe 'Controller: SpringCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  SpringCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SpringCtrl = $controller 'SpringCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
