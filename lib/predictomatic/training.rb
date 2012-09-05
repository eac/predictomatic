require 'benchmark'

module Predictomatic
  class Training

    attr_reader   :timing
    attr_accessor :examples, :model_filename, :options, :verbose

    def initialize(examples, options)
      @examples = examples
      @options  = options
    end

    def train
      @timing = Benchmark.realtime do
        save_examples
        remove_old_cache
        command.run
      end

      File.exist?(model_filename)
    end

    def save_examples
      File.open(example_filename, 'w') do |f|
        examples.each { |example| f.puts(example.to_s)  }
      end
    end

    # VW uses old cache files when regenerating models. I want to isolate runs
    def remove_old_cache
     `rm #{cache_filename}` if File.exist?(cache_filename)
    end

    def command
      command = Command.new(example_filename, default_options.merge!(options))
      command.verbose = verbose
      command
    end

    def default_options
      { :cache => true, :passes => 25, :final_regressor => model_filename, :quiet => true, :ngram => 2, :bit_precision => 22 }
    end

    def cache_filename
      "#{example_filename}.cache"
    end

    def example_filename
      "#{path}/#{name}_dataset.tmp"
    end

    def path
      File.dirname(model_filename)
    end

    def name
      File.basename(model_filename, '.model')
    end

  end
end
