# Bundler
require 'rubygems'
require 'bundler'
Bundler.require

# App
require './app'

# Sinatra
run Sinatra::Application
