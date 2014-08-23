class LastfmUser
  constructor: (data) ->
    @user_name = data.name
    @real_name = data.realname
    if @real_name && @real_name.trim() == ''
      @real_name = undefined
    @url = data.url
    @id = data.id
    @country = data.country
    @age = data.age
    @gender = data.gender
    @play_count = parseInt(data.playcount, 10)
    @date_registered = new Date(1000 * data.registered.unixtime)
    @small_image = data.image.filter((i) -> i.size == 'small')[0]['#text']
    @medium_image = data.image.filter((i) -> i.size == 'medium')[0]['#text']
    @large_image = data.image.filter((i) -> i.size == 'large')[0]['#text']
    @extra_large_image = data.image.filter((i) ->
      i.size == 'extralarge'
    )[0]['#text']

  date_registered_str: ->
    moment(@date_registered).format('MMMM D, YYYY')

(exports ? this).LastfmUser = LastfmUser
