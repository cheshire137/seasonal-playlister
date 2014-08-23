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
  'googleOauth'
]).config(function(TokenProvider) {
  TokenProvider.extendConfig({
    clientId: '1098051467131-qo7g0vgkeie0a7tpldmgh78mq71v9ooj.apps.googleusercontent.com',
    redirectUri: 'http://localhost:9000/oauth2callback',
    scopes: ['https://www.googleapis.com/auth/musicmanager']
  });
});
