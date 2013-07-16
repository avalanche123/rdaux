require 'digest'
require 'pygments'

module RDaux
  class Renderer < Redcarpet::Render::SmartyHTML
    def initialize(options)
      @images_dir = options.delete(:images_dir) { raise ":images_dir is a required option" }
      @web_root   = options.delete(:web_root)   { raise ":web_root is a required option" }

      super(options)
    end

    def block_code(code, language)
      case language
      when nil
        "<pre><code>#{code}</code></pre>"
      when 'diagram'
        ascii2png(code)
      else
        highlight(code, language)
      end
    end

    private

    def highlight(code, language)
      Pygments.highlight(code, :lexer => language)
    rescue MentosError
      "<pre><code class=\"#{language}\">#{code}</code></pre>"
    end

    def ascii2png(code)
      image_id = Digest::MD5.hexdigest(code)
      txt_path = @images_dir + @web_root + "/#{image_id}.txt"

      File.open(txt_path, 'w+') { |f| f.write(code) }

      "<img src=\"#{@web_root}/#{image_id}.png\" alt=\"Text Diagram\">"
    end
  end
end
