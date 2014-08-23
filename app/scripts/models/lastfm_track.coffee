class LastfmTrack
  constructor: (data) ->
    @name = data.name || 'untitled'
    if @name.replace(/\s/g, '') == ''
      @name = 'untitled'
    @mbid = data.mbid
    @artist = data.artist['#text'] || 'no artist'
    if @artist.replace(/\s/g, '') == ''
      @artist = 'no artist'
    @artist_mbid = data.artist.mbid
    @play_count = data.playcount
    @url = data.url
    if @url.indexOf('http://') < 0
      @url = 'http://' + @url
    @id = @mbid || @url
    @small_image = data.image.filter((i) -> i.size == 'small')[0]['#text']
    @medium_image = data.image.filter((i) -> i.size == 'medium')[0]['#text']
    @large_image = data.image.filter((i) -> i.size == 'large')[0]['#text']
    if @artist == 'no artist'
      @artist_url = null
    else
      encoded_artist = encodeURIComponent(@artist).replace(/%20/g, '+')
      @artist_url = "http://www.last.fm/music/#{encoded_artist}"
    unless @large_image
      @large_image = '/images/missing-track-image.png'

(exports ? this).LastfmTrack = LastfmTrack
