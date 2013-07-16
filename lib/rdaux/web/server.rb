require 'unicorn'

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

      def serve(website)
        @app.set(:site, website)
      
        Unicorn::HttpServer.new(@app, {
          :listeners        => @options.fetch(:bind, 'localhost:8080'),
          :worker_processes => @options.fetch(:workers, 4),
          :logger           => @logger
        }).start.join
      end
    end
  end
end
