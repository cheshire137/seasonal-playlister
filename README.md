# SeasonSound

Make spring, summer, fall, and winter playlists from your listening history on Last.fm. Create your playlists on Spotify and Rdio, or export them as CSV or JSON.

**[Use SeasonSound online](http://season-sound.herokuapp.com/)**

## Screenshots

![Last.fm user choice](https://raw.githubusercontent.com/moneypenny/seasonal-playlister/master/screenshot0.png)

----

![Year and season choice](https://raw.githubusercontent.com/moneypenny/seasonal-playlister/master/screenshot1.png)

----

![Playlist creation](https://raw.githubusercontent.com/moneypenny/seasonal-playlister/master/screenshot2.png)

## To Do

- Add ability to create playlists with Google Music. Maybe wait until there's an official public API. :/
- Allow signing into Last.fm to access private scrobbles.

## How to Develop

1. `npm install -g bower`
1. `npm install -g grunt-cli`
1. `npm install`
1. `bower install`
1. `bundle`
1. [Register for an Rdio API account](https://secure.mashery.com/login/rdio.mashery.com/).
1. `cp env.sh.sample env.sh`
1. Modify env.sh and fill in your Rdio API key and secret, as well as a session secret.
1. `source env.sh`
1. `rackup` to start the Sinatra server that serves up the AngularJS app as well as handles requests to Rdio.
1. `grunt serve_assets` to watch for changes to files as you develop and recompile CoffeeScript and SASS as necessary.

## How to Deploy to Heroku

1. [Create a new app on Heroku](https://dashboard.heroku.com/apps).
1. `git remote add heroku git@heroku.com:yourherokuapp.git`
1. `heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git`
1. `heroku config:set NODE_ENV=production`
1. `heroku config:set RACK_ENV=production`
1. `heroku config:set RDIO_API_KEY=your_rdio_api_key`
1. `heroku config:set RDIO_API_SHARED_SECRET=your_rdio_shared_secret`
1. `heroku config:set SESSION_KEY=your_session_key`
1. `heroku ps:scale web=1`
1. `git push heroku master`
