require 'posix/spawn'
require 'sinatra/base'

module RDaux
  module Web
    class Application < Sinatra::Base
      attr_reader :current_section

      enable :logging

      get '/img/ditaa/:id.png/?' do |id|
        txt_path = settings.public_folder + "/img/ditaa/#{id}.txt"
        png_path = settings.public_folder + "/img/ditaa/#{id}.png"

        halt(404) unless File.exists?(txt_path)

        Process::waitpid(POSIX::Spawn.spawn("java", '-jar', settings.ditaa_jar, txt_path, png_path))
        File.unlink(txt_path)

        send_file(png_path, :status => 201)
      end

      get '/' do
        erb(:site)
      end

      def site
        settings.site || halt(500)
      end

      def markdown
        settings.markdown || halt(500)
      end

      def render_markdown(markup)
        markdown.render(markup)
      end
    end
  end
end
