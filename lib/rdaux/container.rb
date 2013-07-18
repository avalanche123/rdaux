require 'redcarpet'
require 'logger'

require 'rdaux/notifier'
require 'rdaux/web/application'
require 'rdaux/web/server'
require 'rdaux/web/site'
require 'rdaux/web/site/generator'
require 'rdaux/renderer'
require 'rdaux/logging_listener'

module RDaux
  module Container
    def webapp
      @webapp ||= with_config(Web::Application) do |app|
        app.set(:markdown,  markdown)
        app.set(:ditaa_jar, ditaa_jar)
      end
    end

    def webserver
      @webserver ||= with_logging(Web::Server.new(webapp, logger, public_folder, options))
    end

    def website
      @website ||= Web::Site.new(title, description, author, directory)
    end

    def generator
      @generator ||= with_logging(Web::Site::Generator.new(markdown, views_dir, public_folder, ditaa_jar, target_dir))
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

    def ditaa_jar
      File.expand_path(__FILE__ + '/../../../vendor/ditaa/ditaa0_9.jar')
    end

    def markdown
      Redcarpet::Markdown.new(Renderer.new({
        :filter_html => true,
        :images_dir  => public_folder,
        :ditaa_root  => '/img/ditaa'
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

    def views_dir
      File.expand_path(__FILE__ + '/../web/views')
    end

    def title
      options.fetch(:title, "RDaux")
    end

    def description
      options.fetch(:description) { "Documentation for <em>#{directory}</em>" }
    end

    def author
      options.fetch(:author) { ENV['USER'] }
    end

    def target_dir
      Pathname(options.fetch(:output_path) { directory + '../site/' })
    end

    def with_logging(obj)
      with_config(obj) {|o| o.add_listener(logging_listener)}
    end

    def with_config(obj)
      obj.tap {|o| yield(o)}
    end
  end
end
