gulp = require('gulp')
sass = require('gulp-sass')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
imagemin = require('gulp-imagemin')
sourcemaps = require('gulp-sourcemaps')
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

gulp.task 'htmls', ['clean'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  gulp.src(paths.htmls)
    .pipe(sourcemaps.init())
      .pipe(slim({
        pretty: true
      }))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build/htmls'))

gulp.task 'javascripts', ['clean'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  gulp.src(paths.javascripts)
    .pipe(sourcemaps.init())
      .pipe(coffee())
      .pipe(uglify())
      .pipe(concat('all.min.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build/javascripts'))

gulp.task 'images', ['clean'], ->
  gulp.src(paths.images)
    # Pass in options to the task
    .pipe(imagemin({optimizationLevel: 5}))
    .pipe(gulp.dest('build/images'))

gulp.task 'stylesheets', ['clean'], ->
  gulp.src(paths.stylesheets)
    .pipe(sass())
    .pipe(gulp.dest('build/stylesheets'))

gulp.task 'fonts', ['clean'], ->
  gulp.src(paths.fonts)
    .pipe(gulp.dest('build/fonts'))

# Rerun the task when a file changes
gulp.task 'watch', ->
  gulp.watch(paths.htmls, ['htmls'])
  gulp.watch(paths.images, ['images'])
  gulp.watch(paths.javascripts, ['javascripts'])
  gulp.watch(paths.stylesheets, ['stylesheets'])

# The default task (called when you run `gulp` from cli)
gulp.task('default', ['watch', 'htmls', 'javascripts', 'stylesheets'])
