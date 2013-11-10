require 'spec_helper'


describe Turtle::Minute do

  let(:store) { Turtle::Redis.new }
  
  before(:each) do 
    store.flushdb
  end

  context "Remaining Header" do 
    
    it "returns the total of remaining requests" do 
      (limit - 1).times do |count|
        get "/endpoint"
      end
      expect(last_response.header["X-Limit-Remaining"]).to eql(1)
    end

  end

  context "Reset Window Header" do
    
    it "returns the reset header" do
      now = Time.local(2013, 9, 1, 12, 0, 0)
      Timecop.freeze(now) do
        get "/endpoint"
        expect(last_response.header["X-Limit-Window-Reset"]).to eql(window)
      end
    end

  end

  context "When reach the limit" do 

    it "returns zero" do 
      limit.times do 
        get "/endpoint"
      end
      expect(last_response.header["X-Limit-Remaining"]).to eql(0)
    end
    
    it "returns 429 status ( TOO MANY REQUEST )" do 
      limit.times do 
        get "/endpoint"
      end
      expect(last_response.status).to eql(429)
      expect(last_response.body).to be_empty
    end

    it "returns zero when goes beyond" do 
      (limit + 10).times do 
        get "/endpoint"
      end
      expect(last_response.header["X-Limit-Remaining"]).to eql(0)
    end

  end

  context "with differents clients" do

    it "handle independent each other" do 

       with_ip('192.168.0.1') do 
        (limit - 1).times do 
          get "/endpoint"
        end
        expect(last_response.header["X-Limit-Remaining"]).to eql(limit-(limit-1))
      end
      
      with_ip('200.0.12.32') do 
        (limit - 2).times do
          get "/endpoint"
        end
        expect(last_response.header["X-Limit-Remaining"]).to eql(limit - (limit-2))
      end

    end
  end
end
