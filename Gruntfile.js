module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      build: {
        src: 'public/js/app.js',
        dest: 'public/build/app.min.js'
      }
    },
    sass: {
      options: {
        cacheLocation: 'tmp/sass_cache'
      },
      dist: {
        files: {
          'public/css/app.css' : 'public/css/app.scss'
        }
      }
    },
    jshint: {
      options: {
        curly: true,
        eqnull: true,
        browser: true,
        smarttabs: true,
        globals: {
          jQuery: true
        },
      },
      uses_defaults: ['public/js/app.js']
    },
    watch: {
      css: {
        files: 'public/css/*.scss',
        tasks: ['sass']
      },
      scripts: {
        options: {
          spawn: false,
        },
        files: 'public/js/*.js',
        tasks: ['jshint', 'uglify']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint'); // JSHint!
  grunt.loadNpmTasks('grunt-contrib-uglify'); // Minify schtuff
  grunt.loadNpmTasks('grunt-contrib-sass'); // CSS with superpowers
  grunt.loadNpmTasks('grunt-contrib-watch'); // Sass --watch

  // Default task(s).
  grunt.registerTask('default', ['watch']);

};
