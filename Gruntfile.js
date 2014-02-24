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
    command: {
      run_cmd: {
        cmd: 'touch tmp/restart.txt'
      }
    },
    watch: {
      css: {
        files: 'public/css/*.scss',
        tasks: ['sass']
      },
      js: {
        options: {
          spawn: false,
        },
        files: 'public/js/*.js',
        tasks: ['jshint', 'uglify']
      },
      app: {
        files: ['**/*.rb', 'Gemfile'],
        tasks: ['command']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint'); // JSHint!
  grunt.loadNpmTasks('grunt-contrib-uglify'); // Minify schtuff
  grunt.loadNpmTasks('grunt-contrib-sass'); // CSS with superpowers
  grunt.loadNpmTasks('grunt-contrib-watch'); // Sass --watch
  grunt.loadNpmTasks('grunt-contrib-commands'); // Run shell commands

  // Default task(s).
  grunt.registerTask('default', ['watch']);

};
