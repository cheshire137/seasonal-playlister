class YearChart
  constructor: (data) ->
    @year = data.year
    @charts = []
    @tracks_loaded = false
    @tracks = []

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

  each_spring: (callback) ->
    @each @spring_charts(), callback

  each_summer: (callback) ->
    @each @summer_charts(), callback

  each_fall: (callback) ->
    @each @fall_charts(), callback

  each_winter: (callback) ->
    @each @winter_charts(), callback

(exports ? this).YearChart = YearChart
