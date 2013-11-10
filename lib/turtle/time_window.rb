module Turtle

  class TimeWindow

    attr_accessor :store
    
    def initialize(app, options = {})
      @app        = app
      @store      = Turtle::Redis.new
    end

    def call(env)
      request = Rack::Request.new(env)
      success, remaining, reset_window = perform(request)
      return build_success(remaining, reset_window, @app.call(env)) if success
      build_limit_reached(remaining, reset_window)
    end

    private

    def build_success(remaining, reset, rack_result)
      status, header, body = *rack_result
      [ status, header.merge( limit_headers(remaining, reset) ) , body ]
    end

    def build_limit_reached(remaining, reset)
      [429, limit_headers(0, reset), [""] ]
    end

    def limit_headers(remaining, reset)
      {
        "X-Limit-Remaining" => remaining,
        "X-Limit-Window-Reset" => reset
      }
    end
 
  end
end