seasonal_app.factory 'LastfmChartsSvc', ($http, NotificationSvc, LastfmSvc) ->
  class LastfmCharts
    constructor: ->
      @year_charts = []
      @user = {}
      @chart = {}
      @neighbors = []
      @load_status =
        charts: false
        chart: false

    on_error: (data, status, headers, config) =>
      Notification.error data

    reset_charts: ->
      @load_status.charts = false
      for key, value of @user
        delete @user[key]
      for i in [0...@year_charts.length] by 1
        @year_charts.splice(idx, 1) for idx, year of @year_charts
      for i in [0...@neighbors.length] by 1
        @neighbors.splice(idx, 1) for idx, neighbor of @neighbors

    get_chart_from_year_charts: (from, to) ->
      for year_chart in @year_charts
        for chart in year_chart.charts
          if chart.from == from && chart.to == to
            return chart
      return false

    load_chart: (from, to) ->
      chart = @get_chart_from_year_charts(from, to)
      unless chart
        chart = new LastfmChart
          from: from
          to: to
      for key, value of chart
        @chart[key] = value

    get_user_neighbors: (user_name) ->
      on_success = (data, status, headers, config) =>
        if data.neighbours
          for i in [0...Math.min(8, data.neighbours.user.length)] by 1
            user_data = data.neighbours.user[i]
            @neighbors.push new LastfmNeighbor(user_data)
      $http.get(Lastfm.get_user_neighbors_url(user_name)).
            success(on_success).error(@on_error)

    get_user_info: (user_name) ->
      on_success = (data, status, headers, config) =>
        if data.user
          for key, value of new LastfmUser(data.user)
            @user[key] = value
      $http.get(Lastfm.get_user_info_url(user_name)).
            success(on_success).error(@on_error)

    get_charts_after_cutoff_date: (charts_data, cutoff_date) ->
      charts = charts_data.map (data) -> new LastfmChart(data)
      charts.filter (chart) -> chart.to_date() >= cutoff_date

  new LastfmCharts()
