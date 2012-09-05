module Predictomatic
  class Command

    attr_accessor :input, :options, :verbose

    def initialize(input, options)
      @input   = input
      @options = options
    end

    def to_s
      "#{executable} #{input} #{command_line_options}"
    end

    def popen
      command = to_s
      puts command if verbose
      IO.popen(command, 'w+') do |io|
        yield io
        io.close_write
        io.read
      end
    end

    def run
      command = to_s
      puts command if verbose?
      system(command)
    end

    def executable
      'vw'
    end

    def verbose?
      @verbose == true
    end

    def command_line_options
      options.map do |key, value|
        command_line = "--#{key}"
        command_line << " #{value}" unless value == true
        command_line
      end.join(' ')
    end

  end
end
