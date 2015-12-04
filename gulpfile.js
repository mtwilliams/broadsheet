var gulp = require('gulp'),
    gutil = require('gulp-util'),
    watch = require('gulp-watch'),
    sass = require('gulp-sass'),
    minifyCss = require('gulp-minify-css'),
    coffee = require('gulp-coffee'),
    uglify = require('gulp-uglify'),
    rev = require('gulp-rev'),
    sourcemaps = require('gulp-sourcemaps');

var styles = ['assets/**/*.{css,scss}'],
    scripts = ['assets/**/*.{coffee,js}'],
    images = ['assets/**/*.{gif,png,svg}'],
    fonts = ['assets/**/*.{ttf,eot,woff}'];

gulp.task('default', ['styles', 'scripts', 'images', 'fonts', 'watch']);

gulp.task('watch', function() {
  watch(styles, function() { gulp.start('styles'); }, {verbose: true});
  watch(scripts, function() { gulp.start('scripts'); }, {verbose: true});
  watch(images, function() { gulp.start('images'); }, {verbose: true});
  watch(fonts, function() { gulp.start('fonts'); }, {verbose: true});
});

gulp.task('styles', function() {
  gulp.src('assets/vendor/**/*.css', {base: 'assets/vendor'})
    .pipe(gutil.env.type === 'production' ? minifyCss({compatibility: 'ie8'}) : gutil.noop())
    .pipe(gulp.dest('./public/styles'));

  gulp.src('assets/styles/**/*.scss', {base: 'assets/styles'})
    .pipe(sourcemaps.init())
      .pipe(sass().on('error', sass.logError))
      .pipe(gutil.env.type === 'production' ? minifyCss({compatibility: 'ie8'}) : gutil.noop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./public/styles'));
});

gulp.task('scripts', function() {
  gulp.src('assets/vendor/**/*.js', {base: 'assets/vendor'})
    .pipe(gutil.env.type === 'production' ? uglify() : gutil.noop())
    .pipe(gulp.dest('./public/scripts'));

  gulp.src('assets/scripts/**/*.coffee', {base: 'assets/scripts'})
    .pipe(sourcemaps.init())
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(gutil.env.type === 'production' ? uglify() : gutil.noop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./public/scripts'));
});

gulp.task('images', function() {
  gulp.src('assets/vendor/**/*.{gif,png,svg}', {base: 'assets/vendor'})
    .pipe(gulp.dest('./public/images'));

  gulp.src('assets/images/**/*', {base: 'assets/images'})
    .pipe(gulp.dest('./public/images'));
});

gulp.task('fonts', function() {
  gulp.src('assets/vendor/**/*.{ttf,eot,woff}', {base: 'assets/vendor'})
    .pipe(gulp.dest('./public/fonts'));

  gulp.src('assets/fonts/**/*', {base: 'assets/fonts'})
    .pipe(gulp.dest('./public/fonts'));
});

gulp.task('revs', function() {
  gulp.src('public/{images,scripts,styles,fonts}/**/*', {base: 'public'})
    .pipe(rev())
    .pipe(gulp.dest('.cache/public'))
    .pipe(rev.manifest('manifest.json'))
    .pipe(gulp.dest('.cache/public'));
});
