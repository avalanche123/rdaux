require 'unicorn'
require 'tmpdir'
require 'fileutils'

module RDaux
  module Web
    class Server
      include Notifier

      def initialize(app, logger, static_dir, options)
        @app        = app
        @logger     = logger
        @static_dir = static_dir
        @options    = options

        notifier_initialize
      end

      def serve(website)
        with_duplicate_static_dir do |dir|
          @app.configure do
            @app.set(:site, website)
            @app.set(:public_folder, dir)
          end

          Unicorn::HttpServer.new(@app, {
            :listeners        => @options.fetch(:bind, 'localhost:8080'),
            :worker_processes => @options.fetch(:workers, 4),
            :logger           => @logger
          }).start.join
        end
      end

      private

      def with_duplicate_static_dir
        Dir.mktmpdir('rdaux') do |dir|
          FileUtils.cp_r(@static_dir + '/.', dir)
          yield(dir)
        end
      end
    end
  end
end
