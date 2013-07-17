require 'pathname'
require 'rdaux/container'

module RDaux
  module CLI
    include RDaux::Container

    attr_reader :options, :directory

    def command(method)
      Proc.new do |opts, args|
        process_options(opts)
        send(method, *args)
      end
    end

    def process_options(options)
      @options = options
    end

    def use_directory(directory)
      raise 'PATH is a required argument to serve command' if directory.nil?

      @directory = Pathname(directory)
    end

    def start_serving(directory = nil)
      use_directory(directory)
      webserver.serve(website)
    end

    def generate_site(directory = nil)
      use_directory(directory)
      generator.generate_static(website)
    end
  end
end
