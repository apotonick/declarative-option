require "test_helper"
require "declarative/option"

class OptionTest < Minitest::Spec
  def Option(*args)
    Declarative::Option(*args)
  end

  # proc
  it { _(Option( ->(*args) { "proc! #{args.inspect}" } ).(1,2)).must_equal "proc! [1, 2]" }
  it { _(Option( lambda { "proc!" } ).()).must_equal "proc!" }

  # proc with instance_exec
  it { _(Option( ->(*args) { "#{self.class} #{args.inspect}" } ).(Object, 1, 2)).must_equal "OptionTest [Object, 1, 2]" }
  it { _(Option( ->(args) { "#{self} #{args.inspect}" }, instance_exec: true ).(Object, keyword_arguments: { a: 3, b: 4, c: 5 })).must_equal "Object {:a=>3, :b=>4, :c=>5}" }
  it { _(Option( ->(a:, b:, **kwargs) { "#{self} #{a} #{b} #{kwargs.inspect}" }, instance_exec: true ).(Object, keyword_arguments: { a: 3, b: 4, c: 5 })).must_equal "Object 3 4 {:c=>5}" }

  # static
  it { _(Option(true).()).must_equal true }
  it { _(Option(nil).()).must_be_nil }
  it { _(Option(false).()).must_equal false }
  # args are ignored.
  it { _(Option(true).(1,2,3)).must_equal true }

  # instance method
  class Hello
    def just(args); "Hello! #{args.inspect}" end
    def hello(*args, **kwargs); "Hello! #{args.inspect} #{kwargs}" end
    def world(a:, b:, **kwargs); "Hello! #{a} #{b} #{kwargs}" end
  end
  it { _(Option(:just).(Hello.new, keyword_arguments: { a: 3, b: 4, c: 5 })).must_equal "Hello! {:a=>3, :b=>4, :c=>5}" }
  it { _(Option(:hello).(Hello.new)).must_equal "Hello! [] {}" }
  it { _(Option(:hello).(Hello.new, 1, 2)).must_equal "Hello! [1, 2] {}" }
  it { _(Option(:world).(Hello.new, keyword_arguments: { a: 3, b: 4, c: 5 })).must_equal "Hello! 3 4 {:c=>5}" }

  #---
  # Callable
  class Callio
    include Declarative::Callable
    def call(); "callable!" end
  end

  it { _(Option(Callio.new).()).must_equal "callable!" }

  #---
  #- :callable overrides the marking class
  class Callme
    def call(*args); "callme! #{args}" end
  end
  it { _(Option(Callme.new, callable: Callme).()).must_equal "callme! []" }

  # { callable: Object } will do
  # 1. proc?
  # 2. method?
  # 3. everything else is treated as callable.
  describe "callable: Object" do
    let (:options) { { callable: Object } }

    it { _(Option(Callme.new,                    options).(1)).must_equal "callme! [1]" }
    # proc is detected before callable.
    it { _(Option(->(*args) { "proc! #{args}" }, options).(1)).must_equal "proc! [1]" }
    # :method is detected before callable.
    it { _(Option(:hello,                        options).(Hello.new, 1)).must_equal "Hello! [1] {}" }
  end

  #---
  #- override #callable?
  class MyCallableOption < Declarative::Option
    def callable?(*); true end
  end

  it { _(MyCallableOption.new.(Callme.new).()).must_equal "callme! []" }
  # proc is detected before callable.
  it { _(MyCallableOption.new.(->(*args) { "proc! #{args.inspect}" }).(1)).must_equal "proc! [1]" }
  # :method is detected before callable.
  it { _(MyCallableOption.new.(:hello).(Hello.new, 1)).must_equal "Hello! [1] {}" }
end
