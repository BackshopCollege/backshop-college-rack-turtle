module Turtle
  class Redis
    extend Forwardable

    def_delegators :@connection, :ttl, :setex, :setnx, :incr, :flushdb
    
    def initialize
      @connection = ::Redis.new
    end
  end
end