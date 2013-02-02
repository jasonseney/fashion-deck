require 'rubygems'
require 'bundler'

Bundler.require

require './app'

run Sinatra::Application

require 'sass/plugin/rack'
Sass::Plugin.options[:syntax] = :scss
use Sass::Plugin::Rack
