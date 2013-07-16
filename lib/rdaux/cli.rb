require 'pathname'
require 'rdaux/container'

module RDaux
  module CLI
    include RDaux::Container

    attr_reader :options
    attr_reader :directory

    def process_options(options)
      @options = options
    end

    def use_directory(directory = nil)
      raise 'PATH is a required argument to serve command' if directory.nil?

      @directory = Pathname(directory)
    end

    def start_serving(directory = nil)
      use_directory(directory)
      webserver.serve(website)
    end

    def generate_site(directory = nil)
      use_directory(directory)
      generator.generate_for_directory(File.expand_path(directory))
    end
  end
end
