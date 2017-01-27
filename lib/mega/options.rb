require "mega/option"

module Mega
    def self.Options(options, config={})
      Options.new.tap do |hsh|
        options.each { |k,v| hsh[k] = Option(v, config) }
      end
    end

  class Options < Hash
    # Evaluates every element and returns a hash.  Accepts context and arbitrary arguments.
    def call(context, *args)
      Hash[ collect { |k,v| [k,v.(context, *args) ] } ]
    end
  end
end
