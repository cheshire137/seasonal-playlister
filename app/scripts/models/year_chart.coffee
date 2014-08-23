class YearChart
  constructor: (data) ->
    @year = data.year
    @charts = []
    @tracks_loaded = false
    @tracks = []
    @filtered_tracks = []

  filter_tracks: (filters) ->
    predicate = (track) ->
      result = true
      if filters.min_play_count
        result = result && track.play_count >= filters.min_play_count
      result
    @filtered_tracks = @tracks.filter(predicate)

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

(exports ? this).YearChart = YearChart
