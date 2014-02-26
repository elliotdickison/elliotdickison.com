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
        files: 'public/script/*.js',
        tasks: ['jshint', 'uglify', 'concat:js'],
      },
      sass: {
        files: 'public/style/*.scss',
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
      uses_defaults: ['public/script/app.js'],
    },

    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
      },
      build: {
        src: 'public/script/app.js',
        dest: 'public/build/js/app.min.js',
      },
    },

    sass: {
      options: {
        cacheLocation: 'tmp/sass_cache',
      },
      dist: {
        files: [
          {
            expand: true,
            cwd: "public/style",
            src: ["**/*.scss"],
            dest: "public/build/css",
            ext: ".css"
          },
          {'public/build/css/font-awesome.css' : 'public/vendor/font-awesome/scss/font-awesome.scss'}
        ],
      },
    },

    concat: {
      js: {
        src: 'public/build/js/*.js',
        dest: 'public/build/all.js'
      },
      css: {
        src: ['public/build/css/normalize.css', 'public/build/css/font-awesome.css', 'public/vendor/prettify/prettify.css', 'public/build/css/app.css'],
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
