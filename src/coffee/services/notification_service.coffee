seasonal_app.factory 'NotificationSvc', ->
  class Notification
    constructor: ->
      @notices = []
      @errors = []

    wipe_notices: ->
      @remove('notice', notice.id) for notice in @notices

    wipe_errors: ->
      @remove('error', error.id) for error in @errors

    wipe_notifications: ->
      @wipe_notices()
      @wipe_errors()

    remove: (type, id) ->
      if type == 'error'
        @errors.splice(idx, 1) for idx, error of @errors when error.id == id
      else
        @notices.splice(idx, 1) for idx, notice of @notices when notice.id == id

    error: (message) ->
      return unless message
      console.error message
      id = @errors.length + 1
      @errors.push
        message: message
        id: id

    notice: (message) ->
      return unless message
      id = @notices.length + 1
      @notices.push
        message: message
        id: id

  new Notification()
