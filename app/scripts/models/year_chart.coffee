class YearChart
  constructor: (data) ->
    @year = data.year
    @charts = []
    @tracks_loaded = false
    @tracks = []
    @filtered_tracks = []

  artists: ->
    hash = {}
    hash[track.artist] = track.artist for track in @tracks
    case_insensitive_sort = (a, b) ->
      return -1 if a.toLowerCase() < b.toLowerCase()
      return 1 if a.toLowerCase() > b.toLowerCase()
      0
    artists = (key for key, value of hash).sort(case_insensitive_sort)
    ['all'].concat(artists)

  has_track: (track) ->
    @tracks.filter((t) -> t.id == track.id).length > 0

  filter_tracks: (filters) ->
    @filtered_tracks.length = 0
    for track in @tracks
      track.matching = false
      track.missing = false
      track.matched = false
      result = true
      if filters.min_play_count
        result = result && track.play_count >= filters.min_play_count
      if filters.artist && filters.artist != 'all'
        result = result && track.artist == filters.artist
      if result
        @filtered_tracks.push track

  season_chart_count: (season) ->
    switch season
      when 'spring' then @spring_charts().length
      when 'summer' then @summer_charts().length
      when 'fall' then @fall_charts().length
      when 'winter' then @winter_charts().length

  spring_charts: ->
    @charts.filter((chart) -> chart.is_spring())

  summer_charts: ->
    @charts.filter((chart) -> chart.is_summer())

  fall_charts: ->
    @charts.filter((chart) -> chart.is_fall())

  winter_charts: ->
    @charts.filter((chart) -> chart.is_winter())

  each: (charts, callback) ->
    index = 0
    num_charts = charts.length
    for chart in charts
      is_last = index == num_charts - 1
      callback chart, index, is_last
      index += 1

  each_season: (season, callback) ->
    switch season
      when 'spring' then @each_spring(callback)
      when 'summer' then @each_summer(callback)
      when 'fall' then @each_fall(callback)
      when 'winter' then @each_winter(callback)

  each_spring: (callback) ->
    @each @spring_charts(), callback

  each_summer: (callback) ->
    @each @summer_charts(), callback

  each_fall: (callback) ->
    @each @fall_charts(), callback

  each_winter: (callback) ->
    @each @winter_charts(), callback

  to_json: ->
    list = []
    for track in @filtered_tracks
      list.push
        musicbrainz_id: track.mbid
        track: track.name
        track_url: track.url
        artist: track.artist
        artist_url: track.artist_url
        play_count: track.play_count
    JSON.stringify(list)

  to_csv: ->
    csv = 'data:text/csv;charset=utf-8,';
    csv += 'MusicBrainz ID,'
    csv += 'Track,'
    csv += 'Track URL,'
    csv += 'Artist,'
    csv += 'Artist URL,'
    csv += "Play Count\n"
    quote = (str) ->
      '"' + str.replace(/"/g, "'") + '"'
    index = 0
    num_tracks = @filtered_tracks.length
    for track in @filtered_tracks
      csv += quote(track.mbid) + ','
      csv += quote(track.name) + ','
      csv += (if track.url then quote(track.url) else '') + ','
      csv += quote(track.artist) + ','
      csv += (if track.artist_url then quote(track.artist_url) else '') + ','
      csv += track.play_count
      csv += "\n" if index < num_tracks - 1
      index += 1
    csv

(exports ? this).YearChart = YearChart
