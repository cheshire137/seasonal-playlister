class YearChart
  constructor: (data) ->
    @year = data.year
    @charts = []

  spring_charts: ->
    @charts.filter((chart) -> chart.is_spring())

  summer_charts: ->
    @charts.filter((chart) -> chart.is_summer())

  fall_charts: ->
    @charts.filter((chart) -> chart.is_fall())

  winter_charts: ->
    @charts.filter((chart) -> chart.is_winter())

  misc: ->
    @charts.filter((chart) -> chart.season() == 'unknown')

(exports ? this).YearChart = YearChart
