'use strict'

describe 'Controller: LastfmUserCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  LastfmUserCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    LastfmUserCtrl = $controller 'LastfmUserCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
