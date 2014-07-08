// Require Gulp plugins and other libraries
var path = require('path');
var gulp = require('gulp');
var gutil = require('gulp-util');
var watch = require('gulp-watch');
var coffee = require('gulp-coffee');
var less = require('gulp-less');
var haml = require('gulp-ruby-haml');
var concat = require('gulp-concat');
var minifyCSS = require('gulp-minify-css');
var clean = require('gulp-clean');


/////////////////////////
// Shared variables /////
/////////////////////////

var coffee_path = './src/coffee';
var less_path = './src/less';
var haml_path = './src/haml';
var lib_js_path = './lib/js';
var tmp_js_path = './tmp';
var out_path = './dist';
var haml_options = {doubleQuote: true};
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
              pipe(gulp.dest(tmp_js_path));
});

// Combine JS files and minify them
gulp.task('minify-js', ['coffee'], function() {
  return gulp.src([lib_js_path + '/jquery-2.1.1.min.js',
                   lib_js_path + '/angular.js',
                   lib_js_path + '/angular-route.min.js',
                   lib_js_path + '/angular-cookies.min.js',
                   lib_js_path + '/angular-animate.min.js',
                   lib_js_path + '/ui-bootstrap-tpls-0.11.0.min.js',
                   tmp_js_path + '/app.js',
                   tmp_js_path + '/models/*.js',
                   tmp_js_path + '/services/*.js',
                   tmp_js_path + '/controllers/*.js',
                   tmp_js_path + '/*.js']).
              pipe(concat('app.js').on('error', on_error)).
              pipe(gulp.dest(out_path));
});

// Remove intermediate JavaScript files
gulp.task('clean-js', ['minify-js'], function () {
  return gulp.src([tmp_js_path + '/controllers/*.js',
                   tmp_js_path + '/models/*.js',
                   tmp_js_path + '/services/*.js',
                   tmp_js_path + '/*.js'],
                  {read: false}).
              pipe(clean().on('error', on_error));
});

// Compile Haml into HTML
gulp.task('haml', function() {
  return gulp.src(haml_path + '/**/*.haml', {read: false}).
              pipe(haml(haml_options).on('error', on_error)).
              pipe(gulp.dest(out_path));
});

// Watch for changes in Haml files
gulp.task('haml-watch', function() {
  return gulp.src(haml_path + '/**/*.haml', {read: false}).
              pipe(watch()).
              pipe(haml(haml_options).on('error', on_error)).
              pipe(gulp.dest(out_path));
});

// Watch files for changes
gulp.task('watch', function() {
  gulp.watch([less_path + '/**/*.less'], ['less']);
  gulp.watch([coffee_path + '/**/*.coffee'], ['clean-js']);
});

// Default task
gulp.task('default', ['watch', 'haml-watch']);

// Compile all files once
gulp.task('run-all', ['haml', 'clean-js', 'less']);
