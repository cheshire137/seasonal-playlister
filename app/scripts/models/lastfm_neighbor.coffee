class LastfmNeighbor
  constructor: (data) ->
    @user_name = data.name
    @real_name = data.realname
    if @real_name && @real_name.trim() == ''
      @real_name = undefined
    @url = data.url
    @match_pct = parseFloat(data.match) * 100
    @small_image = data.image.filter((i) -> i.size == 'small')[0]['#text']
    @medium_image = data.image.filter((i) -> i.size == 'medium')[0]['#text']
    @large_image = data.image.filter((i) -> i.size == 'large')[0]['#text']
    @extra_large_image = data.image.filter((i) ->
      i.size == 'extralarge'
    )[0]['#text']

(exports ? this).LastfmNeighbor = LastfmNeighbor
