// Require Gulp plugins and other libraries
var path = require('path');
var gulp = require('gulp');
var gutil = require('gulp-util');
var watch = require('gulp-watch');
var coffee = require('gulp-coffee');
var less = require('gulp-less');
var haml = require('gulp-ruby-haml');
var minifyCSS = require('gulp-minify-css');


/////////////////////////
// Shared variables /////
/////////////////////////

var coffee_path = './src/coffee';
var less_path = './src/less';
var haml_path = './src/haml';
var out_path = './dist';
var on_error = function(err) { console.error(err.message); };


/////////////////////////
// Tasks ////////////////
/////////////////////////

// Compile LESS into CSS
gulp.task('less', function() {
  return gulp.src(less_path + '/main.less').
              pipe(less({
                     paths: [less_path + '/bootstrap']
                   }).on('error', on_error)).
              pipe(minifyCSS().on('error', on_error)).
              pipe(gulp.dest(out_path));
});

// Compile CoffeeScript into JavaScript
gulp.task('coffee', function() {
  return gulp.src(coffee_path + '/**/*.coffee').
              pipe(coffee({bare: true}).on('error', on_error)).
              pipe(gulp.dest(out_path));
});

// Compile Haml into HTML
gulp.task('haml', function() {
  return gulp.src(haml_path + '/**/*.haml', {read: false}).
              pipe(haml().on('error', on_error)).
              pipe(gulp.dest(out_path));
});

// Watch for changes in Haml files
gulp.task('haml-watch', function() {
  return gulp.src(haml_path + '/**/*.haml', {read: false}).
              pipe(watch()).
              pipe(haml().on('error', on_error)).
              pipe(gulp.dest(out_path));
});

// Watch files for changes
gulp.task('watch', function() {
  gulp.watch([less_path + '/**/*.less'], ['less']);
  gulp.watch([coffee_path + '/**/*.coffee'], ['coffee']);
});

// Default task
gulp.task('default', ['watch', 'haml-watch']);

// Compile all files once
gulp.task('run-all', ['haml', 'coffee', 'less']);
