# SeasonSound

Make spring, summer, fall, and winter playlists from your listening history on Last.fm.

## Screenshots

![Last.fm user choice](https://raw.githubusercontent.com/moneypenny/seasonal-playlister/master/screenshot1.png)

----

![Year and season choice](https://raw.githubusercontent.com/moneypenny/seasonal-playlister/master/screenshot2.png)

----

![Playlist creation](https://raw.githubusercontent.com/moneypenny/seasonal-playlister/master/screenshot3.png)

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
