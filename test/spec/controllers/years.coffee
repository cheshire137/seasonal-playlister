'use strict'

describe 'Controller: YearsCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  YearsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    YearsCtrl = $controller 'YearsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
