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
        tasks: ['sass', 'cssmin', 'concat:css'],
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
        smarttabs: true
      },
      uses_defaults: ['public/script/*.js'],
    },

    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
      },
      // files: {
      //   'public/build/jquery.min.js': 'public/vendor/jquery/dist/jquery.js',
      //   'public/build/q.min.js': 'public/vendor/q/q.js',
      // },
      script: {
        src : 'public/script/*.js',
        dest : 'public/build/script.min.js',
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
            cwd: 'public/style',
            src: ['**/*.scss'],
            dest: 'public/build/',
            ext: '.css'
          },
          // {'public/build/font-awesome.css' : 'public/vendor/font-awesome/scss/font-awesome.scss'}
        ],
      },
    },

    cssmin: {
      build: {
        expand: true,
        cwd: 'public/build/',
        src: ['*.css', '!*.min.css', '!all.css'],
        dest: 'public/build/',
        ext: '.min.css'
      },
    },

    concat: {
      js: {
        src: ['public/build/script.min.js'],
        dest: 'public/build/all.js'
      },
      css: {
        src: ['public/build/normalize.min.css', 'public/build/pygments.min.css', 'public/build/app.min.css'],
        dest: 'public/build/all.css'
      }  
    },

  });
  
  grunt.loadNpmTasks('grunt-contrib-watch'); // Sass --watch
  grunt.loadNpmTasks('grunt-contrib-commands'); // Run shell commands
  grunt.loadNpmTasks('grunt-contrib-jshint'); // JSHint!
  grunt.loadNpmTasks('grunt-contrib-uglify'); // Minify schtuff
  grunt.loadNpmTasks('grunt-contrib-sass'); // CSS with superpowers
  grunt.loadNpmTasks('grunt-contrib-cssmin'); // Minify
  grunt.loadNpmTasks('grunt-contrib-concat'); // Concatenate everything together
  

  // Default task(s).
  grunt.registerTask('default', ['watch']);

};
