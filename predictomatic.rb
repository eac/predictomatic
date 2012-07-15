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

   class ParagraphTokenizer

    def self.tokenize(paragraph)
      features = []

      paragraph.each_line.with_index do |line, line_index|
        group  = FeatureGroup.new("L#{line_index}")
        tokens = line.split
        tokens.map.with_index do |token,index|
          group.features << Feature.new(token)
        end

        features << group
      end

      features
    end

  end

  class FeatureGroup

    attr_accessor :namespace, :features

    def initialize(namespace)
      @namespace = namespace
    end

    def features
      @features ||= []
    end

    def to_s
      string = ''
      string << "|#{namespace} " if namespace
      string << features.join(' ')
    end

  end

  class Feature

    attr_reader :name, :value

    def initialize(name, value = nil)
      @name  = name
      @value = value
    end

    def to_s
      [ escaped_name, value ].compact.join(':')
    end

    def escaped_name
      name.to_s.gsub(':', 'X')
    end

  end

  # Supports named and anonymous features.
  # named       = Example.new(:features => { :price => '.53', :sqft => '.19', :age => '.30', 1954 => nil })
  # anonymous   = Example.new(:features => [ 'a', 'bunch', 'of', 'words' ])
  # https://github.com/JohnLangford/vowpal_wabbit/wiki/Input-format
  class Example

    attr_accessor :score, :importance, :label, :features

    def initialize(options)
      @score      = options[:score]      || 1
      @importance = options[:importance] || 1.0
      @label      = options[:label]
      @features   = options[:features]
    end

    def to_s
      featured = features
      featured.first.namespace = nil # nasty hack until I can figure out how to specify namespaces for the first feature group
      "#{prefix}#{featured.join(' ')}"
    end

    def features
      if @features.is_a?(String)
        ParagraphTokenizer.tokenize(@features)
      else
        @features
      end
    end

    def prefix
      prefix = [ score, importance, vowpal_label ].compact.join(' ')
      prefix = "#{prefix}| " unless prefix.empty?
      prefix
    end

    def vowpal_label
      "'#{label}" if label
    end

  end

  class Question

    attr_reader :name, :examples

    def initialize(name, examples)
      @name     = name
      @examples = examples
    end

    def save
      File.open(filename, 'w') do |f|
        examples.each { |example| f.puts(example.to_s) }
      end
    end

    def filename
      "data/#{name}_question.tmp"
    end

  end

end
