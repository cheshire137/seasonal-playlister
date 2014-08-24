'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.TrackCleanupSvc
 # @description
 # # TrackCleanupSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'TrackCleanupSvc', ->
    class TrackCleanup
      strip_after_hyphen: (str) ->
        hyphen_idx = str.indexOf(' - ')
        if hyphen_idx > -1
          # I Don't Wanna Care - feat. Jim => I Don't Wanna Care
          str = str.substring(0, hyphen_idx)
        str

      strip_square_brackets: (str) ->
        open_sq_bracket_idx = str.indexOf('[')
        if open_sq_bracket_idx > -1
          # Pharaohs [feat. Roses Gabor] whee => Pharoahs  whee
          close_sq_bracket_idx = str.indexOf(']', open_sq_bracket_idx)
          if close_sq_bracket_idx > -1
            str = str.substring(0, open_sq_bracket_idx) +
                         str.substring(close_sq_bracket_idx + 1)
          else
            str = str.substring(0, open_sq_bracket_idx)
        str

      strip_parentheses: (str) ->
        open_paren_idx = str.indexOf('(')
        if open_paren_idx > -1
          # Pharaohs (feat. Roses Gabor) whee => Pharoahs  whee
          close_paren_idx = str.indexOf(')', open_paren_idx)
          if close_paren_idx > -1
            str = str.substring(0, open_paren_idx) +
                         str.substring(close_paren_idx + 1)
          else
            str = str.substring(0, open_paren_idx)
        str

      clean_track_name: (track_name) =>
        clean_name = @strip_after_hyphen(track_name)
        clean_name = @strip_square_brackets(clean_name)
        clean_name = @strip_parentheses(clean_name)
        clean_name.trim()

    new TrackCleanup()
