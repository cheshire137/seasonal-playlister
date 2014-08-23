'use strict';

/**
 * @ngdoc overview
 * @name seasonSoundApp
 * @description
 * # seasonSoundApp
 *
 * Main module of the application.
 */
angular.module('seasonSoundApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngAnimate',
  'ngRoute',
  'ui.bootstrap',
  'LocalStorageModule'
]).config(['localStorageServiceProvider',
          function(localStorageServiceProvider) {
            localStorageServiceProvider.setPrefix('seasonSound');
          }]);
