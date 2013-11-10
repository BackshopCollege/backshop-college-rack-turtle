require "turtle/version"
require 'redis'

module Turtle
  autoload :Redis     , "turtle/redis_store"
  autoload :TimeWindow, "turtle/time_window"
  autoload :Minute,     "turtle/minute"
end
