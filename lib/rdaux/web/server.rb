require 'unicorn'
require 'pathname'

module RDaux
  module Web
    class Server
      include Notifier

      def initialize(app, logger, options)
        @app     = app
        @logger  = logger
        @options = options

        notifier_initialize
      end

      def serve_from_directory(directory)
        directory   = Pathname(directory)
        title       = @options.fetch(:title)       { "RDaux" }
        description = @options.fetch(:description) { "Documentation for <em>#{directory.relative_path_from(Pathname(ENV['PWD']))}</em>" }
        author      = @options.fetch(:author)      { ENV['USER'] }

        @app.set(:site, Site.new(title, description, author, directory))
      
        Unicorn::HttpServer.new(@app, {
          :listeners        => @options.fetch(:bind, 'localhost:8080'),
          :worker_processes => @options.fetch(:workers, 4),
          :logger           => @logger
        }).start.join
      end
    end
  end
end
