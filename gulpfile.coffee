gulp = require('gulp')
sass = require('gulp-ruby-sass')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
imagemin = require('gulp-imagemin')
sourcemaps = require('gulp-sourcemaps')
autoprefixer = require('gulp-autoprefixer')
slim = require("gulp-slim")
del = require('del')

paths =
  htmls: "src/htmls/**/*"
  fonts: "src/fonts/**/*"
  images: "src/images/**/*"
  javascripts: "src/javascripts/**/*"
  stylesheets: "src/stylesheets/**/*"

# Not all tasks need to use streams
# A gulpfile is just another node program and you can use all packages available on npm
gulp.task 'clean', (cb) ->
  # You can use multiple globbing patterns as you would with `gulp.src`
  del ['build'], cb

gulp.task 'slim', ['clean'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  gulp.src paths.htmls
    .pipe sourcemaps.init()
      .pipe slim pretty: true
    .pipe gulp.dest('build/htmls')

gulp.task 'js', ['clean'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  gulp.src paths.javascripts
    .pipe sourcemaps.init()
      .pipe coffee()
    .pipe sourcemaps.write()
    .pipe gulp.dest('build/javascripts')

gulp.task 'js-min', ['clean'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  gulp.src paths.javascripts
    .pipe sourcemaps.init()
      .pipe coffee()
      .pipe uglify()
      .pipe concat('all.min.js')
    .pipe sourcemaps.write()
    .pipe gulp.dest('build/javascripts')

gulp.task 'img', ['clean'], ->
  gulp.src paths.images
    # Pass in options to the task
    .pipe imagemin({optimizationLevel: 5})
    .pipe gulp.dest('build/images')

gulp.task 'css', ['clean'], ->
  gulp.src paths.stylesheets
    .pipe sass({})
    .pipe autoprefixer()
    .pipe gulp.dest('build/stylesheets')

gulp.task 'fonts', ['clean'], ->
  gulp.src paths.fonts
    .pipe gulp.dest('build/fonts')

# Rerun the task when a file changes
gulp.task 'watch', ->
  gulp.watch paths.htmls, ['slim']
  gulp.watch paths.images, ['img']
  gulp.watch paths.javascripts, ['js', 'js-min']
  gulp.watch paths.stylesheets, ['css']

# The default task (called when you run `gulp` from cli)
gulp.task('default', ['slim', 'img', 'js', 'js-min', 'css', 'fonts'])
