var gulp = require('gulp'),
  merge = require('merge-stream'),
  addsrc = require('gulp-add-src'),
  del = require('del'),
  plugins = require('gulp-load-plugins')()

var js_custom = ['src/KaarePlatform.js']

gulp.task('clean', function(cb) { del(['build'], cb) })

gulp.task('build',['clean'], function () {
  return gulp.src(js_custom)
    .pipe(plugins.jshint())
    .pipe(plugins.jshint.reporter('default'))
    .pipe(plugins.jshint.reporter('fail'))
    .pipe(plugins.traceur())
    .pipe(plugins.concat('kaare.platform.js'))
    .pipe(gulp.dest('build'))
})

gulp.task('default', function () {
  plugins.watch(['src/**/*.js'], function (files, cb) {
    gulp.start('build', cb)
  })
});
