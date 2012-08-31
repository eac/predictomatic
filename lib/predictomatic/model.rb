module Predictomatic
  class Model

    attr_accessor :examples, :name

    def answer(question)
      command = "vw -i #{filename} -t #{question.filename} -p /dev/stdout --quiet"
      puts command
      system(command)
    end

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
