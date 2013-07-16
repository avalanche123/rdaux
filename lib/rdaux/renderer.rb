require 'digest'
require 'pygments'

module RDaux
  class Renderer < Redcarpet::Render::SmartyHTML
    def initialize(options)
      @images_dir = options.delete(:images_dir) { raise ":images_dir is a required option" }
      @ditaa_root = options.delete(:ditaa_root) { raise ":ditaa_root is a required option" }

      super(options)
    end

    def block_code(code, language)
      case language
      when nil
        "<pre><code>#{code}</code></pre>"
      when 'ditaa'
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
      txt_path = @images_dir + @ditaa_root + "/#{image_id}.txt"

      File.open(txt_path, 'w+') { |f| f.write(code) }

      "<img src=\"#{@ditaa_root}/#{image_id}.png\" alt=\"Text Diagram\" class=\"img-rounded img-polaroid\">"
    end
  end
end
