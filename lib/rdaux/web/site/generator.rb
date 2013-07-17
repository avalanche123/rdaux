require 'tilt'
require 'posix/spawn'

module RDaux
  module Web
    class Site
      class Generator
        include Notifier

        def initialize(markdown, views_dir, static_dir, ditaa_jar, target_dir)
          @markdown   = markdown
          @views_dir  = views_dir
          @static_dir = static_dir
          @ditaa_jar  = ditaa_jar
          @target_dir = target_dir

          @cached_templates = {}
          notifier_initialize
        end

        def generate_static(website)
          with_duplicate_static_dir do |dir|
            File.open("#{dir}/index.html", 'w+') do |f|
              f.write(erb(:site, :locals => {:site => website}))
            end

            Dir.glob("#{dir}/img/ditaa/*.txt").each do |txt_path|
              Process::waitpid(POSIX::Spawn.spawn("java", '-jar', @ditaa_jar, txt_path))
              File.unlink(txt_path)
            end

            if File.directory?(@target_dir)
              FileUtils.cp_r("#{dir}/.", @target_dir)
            else
              FileUtils.mv(dir, @target_dir)
            end
          end
        end

        private

        def with_duplicate_static_dir
          dir = Dir.mktmpdir('rdaux')

          FileUtils.cp_r("#{@static_dir}/.", dir)
          yield(dir)
        ensure
          FileUtils.remove_entry_secure(dir) if File.directory?(dir)
        end

        def erb(view, options)
          unless @cached_templates.has_key?(view)
            @cached_templates[view] = Tilt[:erb].new("#{@views_dir}/#{view}.erb", 1, {
              :default_encoding => 'UTF-8'
            })
          end
          @cached_templates[view].render(self, options.fetch(:locals, {}))
        end

        def render_markdown(markup)
          @markdown.render(markup)
        end
      end
    end
  end
end
