require 'pry'

module Turtle

  class Minute < TimeWindow

    #
    # 10 requests / 60 seconds 
    #
    attr_accessor :max_window_request, :window_length

    def initialize(app, options)
      super
      @max_window_request   = options[:maximum] || 10
      @window_length        = 60 #60 seconds
    end

    def perform(request)
      setup(request.ip)
      count        = increment(request.ip)
      allow        = allowed?(count)
      [allow, remaining(count), ttl(request.ip)]
    end

    private

    def remaining(count)
      (@max_window_request - count) > 0 ? (@max_window_request - count) : 0
    end

    def setup(client)
      if store.setnx(key(client), 0)
        store.setex(key(client), @window_length, 0)
      end
    end

    def increment(client)
      store.incr(key(client))
    end

    def allowed?(value)
      value < @max_window_request
    end

    def ttl(client)
      store.ttl(key(client))
    end

    def key(client)
      [client, Time.now.strftime('%Y%m%d%M')].join(':')
    end

  end
end