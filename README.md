# SeasonSound

Make spring, summer, fall, and winter playlists from your listening history on Last.fm. Create your playlists on Spotify or export them as CSV or JSON.

## Screenshots

![Last.fm user choice](https://raw.githubusercontent.com/cheshire137/seasonal-playlister/master/screenshot0.png)

----

![Year and season choice](https://raw.githubusercontent.com/cheshire137/seasonal-playlister/master/screenshot1.png)

----

![Playlist creation](https://raw.githubusercontent.com/cheshire137/seasonal-playlister/master/screenshot2.png)

## To Do

- Add ability to create playlists with Google Music. Maybe wait until there's an official public API. :/
- Offer sorting filtered tracks by name, artist, and play count.
- Tests!

## How to Develop

### First Time

You will need npm, Ruby, and bundler installed.

```bash
npm install -g bower
npm install -g grunt-cli
cp env.sh.sample env.sh
```

[Register for a Last.fm API account](http://www.last.fm/api/account/create).
Modify env.sh and fill in your Last.fm API keys and secrets, as well as a session key.
You can run `openssl rand -base64 40` to generate a random session key.

### Every Time

```bash
npm install # also installs necessary gems and bower packages
foreman start -f Procfile.dev
open http://localhost:5000
```

The Sinatra server serves up the AngularJS app as well as watches for changes to
files as you develop, to recompile CoffeeScript and SASS as necessary.

## How to Deploy to Heroku

[Create a new app on Heroku](https://dashboard.heroku.com/apps).

```bash
git remote add heroku git@heroku.com:yourherokuapp.git
heroku config:add BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-ruby.git
heroku config:set NODE_ENV=production
heroku config:set LASTFM_API_KEY=your_lastfm_api_key
heroku config:set RACK_ENV=production
heroku config:set SESSION_KEY=your_session_key
./deploy.sh
heroku ps:scale web=1
```
