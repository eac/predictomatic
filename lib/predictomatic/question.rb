module Predictomatic

  # Predicts an answer for the question using the given model
  class Question

    attr_reader :examples

    def initialize(examples)
      @examples = examples
    end

    def to_s
      examples.join("\n")
    end

    def answer(model)
      command = "vw -i #{model.filename} -t /dev/stdin -p /dev/stdout --quiet"
      puts command

      IO.popen(command, 'w+') do |io|
        io.puts(self.to_s)
        io.close_write
        io.read
      end
    end

  end
end
