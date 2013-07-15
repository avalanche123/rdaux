require 'pygments'

module RDaux
  class Renderer < Redcarpet::Render::SmartyHTML
    def block_code(code, language)
      Pygments.highlight(code, :lexer => language)
    rescue MentosError
      "<pre><code class=\"#{language}\">#{code}</code></pre>"
    end
  end
end
