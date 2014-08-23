'use strict'

describe 'Controller: SummerCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  SummerCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SummerCtrl = $controller 'SummerCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
