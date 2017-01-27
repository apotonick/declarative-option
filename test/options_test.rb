require 'test_helper'
require 'mega/options'

class UberOptionsTest < MiniTest::Spec
  let (:dynamic) { Mega::Options({ :volume =>1, :style => "Punkrock", :track => Proc.new { |i| i.to_s } }, instance_exec: true) }

  describe "#call" do
    it { dynamic.(Object.new, 999).must_equal({:volume =>1, :style => "Punkrock", :track => "999"}) }

    describe "static" do
      let (:static) { Mega::Options(:volume =>1, :style => "Punkrock") }

      it { static.(nil).must_equal({:volume =>1, :style => "Punkrock"}) }
    end
  end

  describe "Options() with value options" do
    let (:context) { Struct.new(:style).new("Rocksteady") }

    it "accepts :instance_exec" do
      options = Mega::Options( { volume: 1, style: lambda { style } }, instance_exec: true )

      options.(context).must_equal({:volume=>1, :style=>"Rocksteady"})
    end

    it "doesn't set :instance_exec per default" do
      style = "Metal"
      options = Mega::Options( { volume: 1, style: lambda { |ctx| style } } )
      options.(context).must_equal({:volume=>1, :style=>"Metal"})
    end
  end
end
