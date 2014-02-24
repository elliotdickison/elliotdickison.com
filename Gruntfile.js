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
    watch: {
      css: {
        files: 'public/css/*.scss',
        tasks: ['sass']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify'); // Minify schtuff
  grunt.loadNpmTasks('grunt-contrib-sass'); // CSS with superpowers
  grunt.loadNpmTasks('grunt-contrib-watch'); // Sass --watch

  // Default task(s).
  grunt.registerTask('default', ['uglify', 'watch']);

};
