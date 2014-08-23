'use strict'

describe 'Controller: GoogleMusicCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  GoogleMusicCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GoogleMusicCtrl = $controller 'GoogleMusicCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
