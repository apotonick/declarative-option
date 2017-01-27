module Mega
  Callable = Module.new

  def self.Option(value, options={})
    Option.new.(value, options)
  end

  class Option
    def call(value, options={})
      if value.is_a?(Proc)
        return ->(context, *args) { context.instance_exec(*args, &value) } if options[:instance_exec]
        return value
      end

      return ->(context, *args){ context.send(value, *args) } if value.is_a?(Symbol)
      return value                                            if callable?(value, options)
      ->(*) { value }
    end

    def callable?(value, options)
      value.is_a?(options[:callable] || Callable)
    end
  end
end
