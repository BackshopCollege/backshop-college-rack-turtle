describe Turtle::Minute do

  let(:subject) { Turtle::Minute.new(Object.new, options)}
  
  context "initialization" do 
  
    context "max_window_request" do 
      let(:options) { { maximum: 8  } }

      it "defautls" do
        minute = Turtle::Minute.new(Object.new, {})
        expect(minute.max_window_request).to eql(10)
      end
      
      it "options" do 
        expect(subject.max_window_request).to eql(8)
      end
    end

    context "window length" do 
      
      let(:options) { { window_length: 120  } }

      it "options" do
        expect(subject.window_length).to eql(120)
      end

      it "default" do 
        minute = Turtle::Minute.new(Object.new, {})
        expect(minute.window_length).to eql(60)
      end

    end
  end
end