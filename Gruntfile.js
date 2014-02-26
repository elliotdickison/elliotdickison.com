module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    watch: {
      app: {
        files: ['**/*.rb', 'Gemfile'],
        tasks: ['command'],
      },
      js: {
        options: {
          spawn: false,
        },
        files: 'public/js/*.js',
        tasks: ['jshint', 'uglify', 'concat:js'],
      },
      sass: {
        files: 'public/css/*.scss',
        tasks: ['sass', 'concat:css'],
      },
    },

    command: {
      run_cmd: {
        cmd: 'touch tmp/restart.txt',
      },
    },

    jshint: {
      options: {
        curly: true,
        eqnull: true,
        browser: true,
        smarttabs: true,
        globals: {
          jQuery: true,
        },
      },
      uses_defaults: ['public/js/app.js'],
    },

    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
      },
      build: {
        src: 'public/js/app.js',
        dest: 'public/build/app.min.js',
      },
    },

    sass: {
      options: {
        cacheLocation: 'tmp/sass_cache',
      },
      dist: {
        files: {
          'public/css/app.css' : 'public/css/app.scss',
        },
      },
    },

    concat: {
      js: {
        src: 'public/js/*.min.js',
        dest: 'public/build/all.min.js'
      },
      css: {
        src: ['public/css/normalize.css', 'public/css/fontawesome.css', 'public/prettify/prettify.css', 'public/css/app.css'],
        dest: 'public/build/all.css'
      }  
    },

  });
  
  grunt.loadNpmTasks('grunt-contrib-watch'); // Sass --watch
  grunt.loadNpmTasks('grunt-contrib-commands'); // Run shell commands
  grunt.loadNpmTasks('grunt-contrib-jshint'); // JSHint!
  grunt.loadNpmTasks('grunt-contrib-uglify'); // Minify schtuff
  grunt.loadNpmTasks('grunt-contrib-sass'); // CSS with superpowers
  grunt.loadNpmTasks('grunt-contrib-concat'); // JSHint!
  

  // Default task(s).
  grunt.registerTask('default', ['watch']);

};
