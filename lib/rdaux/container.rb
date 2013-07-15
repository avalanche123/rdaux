require 'redcarpet'
require 'logger'

require 'rdaux/notifier'
require 'rdaux/web'
require 'rdaux/renderer'
require 'rdaux/logging_listener'

module RDaux
  module Container
    def webapp_builder
      @webapp_builder ||= with_config(Web::Application) do |app|
        app.set(:public_folder, public_folder)
        app.set(:markdown,      markdown)
      end
    end

    def server
      @server ||= with_logging(Web::Server.new(webapp_builder, logger, options))
    end

    def generator
      @generator ||= Generator.new(options)
    end

    def logger
      with_config(Logger.new($stderr)) do |l|
        l.level     = log_level
        l.formatter = proc { |s, d, p, m| "%s | %-10s %s\n" % [d.strftime("%T,%L"), "[#{s}]", m] }
      end
    end

    def log_level
      Logger.const_get(@options.fetch(:log_level, 'info').upcase)
    end

    def logging_listener
      @logging_listener ||= LoggingListener.new(logger)
    end

    def public_folder
      File.expand_path(__FILE__ + '/../../../public')
    end

    def markdown
      Redcarpet::Markdown.new(Renderer.new({
        :filter_html => true
      }), {
        :no_intra_emphasis   => true,
        :tables              => true,
        :fenced_code_blocks  => true,
        :autolink            => true,
        :space_after_headers => true,
        :superscript         => true,
        :underline           => true,
        :highlight           => true
      })
    end

    private

    def with_logging(obj)
      with_config(obj) {|o| o.add_listener(logging_listener)}
    end

    def with_config(obj)
      obj.tap {|o| yield(o)}
    end
  end
end
