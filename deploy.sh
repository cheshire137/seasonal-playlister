#!/usr/bin/env bash

node_modules/.bin/grunt heroku && git add -A dist && git commit -m "Update dist/"
git push origin master
git push heroku master
