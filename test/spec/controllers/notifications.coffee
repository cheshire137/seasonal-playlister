'use strict'

describe 'Controller: NotificationsCtrl', ->

  # load the controller's module
  beforeEach module 'seasonSoundApp'

  NotificationsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    NotificationsCtrl = $controller 'NotificationsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
