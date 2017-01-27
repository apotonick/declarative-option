require 'test_helper'
require 'mega/options'

class UberOptionsTest < MiniTest::Spec
  def Options(*args)
    Mega::Options(*args)
  end

  let (:dynamic) { Options(:volume =>1, :style => "Punkrock", :track => Proc.new { |i| i.to_s }) }

  describe "#call" do
    it { dynamic.(Object.new, 999).must_equal({:volume =>1, :style => "Punkrock", :track => "999"}) }

    describe "static" do
      let (:static) { Options(:volume =>1, :style => "Punkrock") }

      it { static.(nil).must_equal({:volume =>1, :style => "Punkrock"}) }
    end
  end
end
