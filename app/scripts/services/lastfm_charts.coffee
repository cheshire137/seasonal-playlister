'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.lastfmCharts
 # @description
 # # lastfmCharts
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'LastfmChartsSvc', ($q, $http, LastfmSvc, localStorageService) ->
    class LastfmCharts
      constructor: ->
        @year_charts = []
        @user = {}
        @chart = {}
        @neighbors = []
        @load_status =
          charts: false
          chart: false
          neighbors: false

      reset_charts: ->
        @load_status.charts = false
        @load_status.neighbors = false
        @year_charts.length = 0
        @neighbors.length = 0

      initialize_year_charts: (charts) ->
        for week_chart in charts
          year = week_chart.year()
          year_chart = @year_charts.filter((obj) -> obj.year == year)[0]
          if year_chart
            year_chart.charts.push week_chart
          else
            year_chart = new YearChart
              year: year
            year_chart.charts.push week_chart
            @year_charts.push year_chart

      get_year_chart_from_year_charts: (year) ->
        for year_chart in @year_charts
          return year_chart if year_chart.year == year
        return false

      load_year_chart: (year) ->
        year = parseInt(year, 10)
        chart = @get_year_chart_from_year_charts(year)
        for key, value of chart
          @chart[key] = value
        @load_status.chart = true

      get_user_neighbors: (user_name) ->
        deferred = $q.defer()
        on_success = (data, status, headers, config) =>
          if data.neighbours
            for i in [0...Math.min(8, data.neighbours.user.length)] by 1
              user_data = data.neighbours.user[i]
              @neighbors.push new LastfmNeighbor(user_data)
          @load_status.neighbors = true
          deferred.resolve()
        on_error = (data, status, headers, config) =>
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        $http.get(LastfmSvc.get_user_neighbors_url(user_name)).
              success(on_success).error(on_error)
        deferred.promise

      get_user_info: (user_name) ->
        deferred = $q.defer()
        on_success = (data, status, headers, config) =>
          if data.user
            for key, value of new LastfmUser(data.user)
              @user[key] = value
          deferred.resolve()
        on_error = (data, status, headers, config) =>
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        $http.get(LastfmSvc.get_user_info_url(user_name)).
              success(on_success).error(on_error)
        deferred.promise

      get_charts_after_cutoff_date: (charts_data, cutoff_date) ->
        charts = charts_data.map (data) -> new LastfmChart(data)
        charts.filter (chart) -> chart.to_date() >= cutoff_date

      get_weekly_chart_list_after_date: (user, cutoff_date) ->
        deferred = $q.defer()
        on_success = (data, status, headers, config) =>
          if data.weeklychartlist
            charts_data = data.weeklychartlist.chart.slice(0).reverse()
            charts = @get_charts_after_cutoff_date(charts_data, cutoff_date)
            @initialize_year_charts charts
            deferred.resolve()
          else if data.error
            deferred.reject({name: data.error})
          @load_status.charts = true
        on_error = (data, status, headers, config) =>
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
          @load_status.charts = true
        $http.get(LastfmSvc.get_weekly_chart_list_url(user)).
              success(on_success).error(on_error)
        deferred.promise

      get_weekly_track_chart: (user, chart) ->
        deferred = $q.defer()
        storage_key = "#{user}_#{chart.from}_#{chart.to}"
        stored_tracks = localStorageService.get(storage_key)
        if stored_tracks
          for track in stored_tracks
            chart.tracks.push(track)
          deferred.resolve()
        else
          on_success = (data) =>
            if data.weeklytrackchart.track
              for track_data in data.weeklytrackchart.track
                chart.tracks.push(new LastfmTrack(track_data))
              localStorageService.set(storage_key, JSON.stringify(chart.tracks))
              deferred.resolve()
            else if data.error
              deferred.reject({name: data.error})
            else
              deferred.resolve()
          on_error = (data, status, headers, config) ->
            deferred.reject
              name: 'error_response'
              data: data
              status: status
              headers: headers
              config: config
          $http.get(LastfmSvc.get_weekly_track_chart_url(user, chart)).
                success(on_success).error(on_error)
        deferred.promise

    new LastfmCharts()
