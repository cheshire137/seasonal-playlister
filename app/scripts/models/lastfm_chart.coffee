class LastfmChart
  constructor: (data) ->
    @tracks = []
    @from = data.from
    @to = data.to

  track_count: ->
    @tracks.length

  is_in_season: (season_start, season_end) ->
    chart_start = @from_date()
    chart_start >= season_start && chart_start <= season_end

  # spring: March 21 - June 20
  is_spring: ->
    year = @year()
    season_start = new Date(year, 2, 21)
    season_end = new Date(year, 5, 20)
    @is_in_season season_start, season_end

  # summer: June 21 - September 22
  is_summer: ->
    year = @year()
    season_start = new Date(year, 5, 21)
    season_end = new Date(year, 8, 22)
    @is_in_season season_start, season_end

  # fall: September 23 - December 20
  is_fall: ->
    year = @year()
    season_start = new Date(year, 8, 23)
    season_end = new Date(year, 11, 20)
    @is_in_season season_start, season_end

  # winter: December 21 - March 20
  is_winter: ->
    year = @year()
    season_start_month = 11
    season_start_day = 21
    season_end_month = 2
    season_end_day = 20
    season_start = new Date(year - 1, season_start_month, season_start_day)
    season_end = new Date(year, season_end_month, season_end_day)
    return true if @is_in_season(season_start, season_end)
    season_start = new Date(year, season_start_month, season_start_day)
    season_end = new Date(year + 1, season_end_month, season_end_day)
    @is_in_season season_start, season_end

  # spring: March 21 - June 20
  # summer: June 21 - September 22
  # fall: September 23 - December 20
  # winter: December 21 - March 20
  season: ->
    return 'spring' if @is_spring()
    return 'summer' if @is_summer()
    return 'fall' if @is_fall()
    return 'winter' if @is_winter()
    'unknown'

  from_date: ->
    new Date(1000 * @from)

  to_date: ->
    new Date(1000 * @to)

  playlist_name: (min_play_count) ->
    if @tracks.length < 1
      return @to_s()
    @top_artists_str(min_play_count) + ' - ' + @month_range_str()

  # Returns a comma-separated string of the top 3 artists in this chart.
  top_artists_str: (min_play_count) ->
    artist_counts = {}
    for track in @tracks when track.play_count >= min_play_count
      artist = track.artist
      if artist_counts.hasOwnProperty(artist)
        artist_counts[artist] += track.play_count
      else
        artist_counts[artist] = track.play_count
    tuples = ([artist, count] for artist, count of artist_counts)
    tuples.sort (a, b) ->
      if a[1] < b[1] then 1 else if a[1] > b[1] then -1 else 0
    limit = Math.min(3, tuples.length)
    top_artist_counts = tuples.slice(0, limit)
    (artist_count[0] for artist_count in top_artist_counts).join(', ')

  year: ->
    parseInt(moment(@from_date()).format('YYYY'), 10)

  same_year: ->
    @from_date().getFullYear() == @to_date().getFullYear()

  same_month: ->
    same_month = @from_date().getMonth() == @to_date().getMonth()

  from_date_str: ->
    if @same_year()
      moment(@from_date()).format('MMMM D')
    else
      moment(@from_date()).format('MMMM D, YYYY')

  to_date_str: ->
    if @same_year() && @same_month()
      moment(@to_date()).format('D, YYYY')
    else
      moment(@to_date()).format('MMMM D, YYYY')

  from_date_utc_str: ->
    @from_date().toUTCString()

  to_date_utc_str: ->
    @to_date().toUTCString()

  month_range_str: ->
    if @same_year() && @same_month()
      moment(@from_date()).format('MMM YYYY')
    else
      moment(@from_date()).format('MMM') + '-' +
          moment(@to_date()).format('MMM YYYY')

  to_s: ->
    if @same_year() && @same_month()
      "#{@from_date_str()}-#{@to_date_str()}"
    else
      "#{@from_date_str()} to #{@to_date_str()}"

(exports ? this).LastfmChart = LastfmChart
