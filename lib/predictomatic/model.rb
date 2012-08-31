module Predictomatic

  # Generates and persists a model based on the given examples
  class Model

    attr_accessor :examples, :name

    def save
      # Seems like VW uses old cache files when regenerating models
      `rm #{cache_filename}` if File.exist?(cache_filename)

      File.open(example_filename, 'w') do |f|
        examples.each { |example| f.puts(example.to_s)  }
      end

      command = "vw #{example_filename} -c --passes 25 -f #{filename} --quiet --ngram 2 -b 22"
      puts command
      system(command)

      File.exist?(filename)
    end

    def cache_filename
      "#{example_filename}.cache"
    end

    def filename
      "data/#{name}.model"
    end

    def example_filename
      "data/#{name}_dataset.tmp"
    end

  end
end
