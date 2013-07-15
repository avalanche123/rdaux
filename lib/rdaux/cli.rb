require 'rdaux/container'

module RDaux
  module CLI
    include RDaux::Container

    attr_reader :options

    def process_options(options)
      @options = options
    end

    def start_serving(directory = nil)
      raise 'PATH is a required argument to serve command' if directory.nil?

      server.serve_from_directory(File.expand_path(directory))
    end

    def generate_site(directory = nil)
      raise 'PATH is a required argument to generate command' if directory.nil?

      generator.generate_for_directory(File.expand_path(directory))
    end
  end
end
