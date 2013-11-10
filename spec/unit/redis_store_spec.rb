require 'spec_helper'

describe Turtle::Redis do 
  subject { Turtle::Redis.new }

  its(:ttl)     { respond_to :ttl    }
  its(:setex)   { respond_to :setex  }
  its(:setnx)   { respond_to :setnx  }
  its(:incr)    { respond_to :incr   }
  its(:flushdb) { respond_to :flushdb}

end