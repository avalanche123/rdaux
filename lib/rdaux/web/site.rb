require 'pathname'

module RDaux
  module Web
    class Site
      attr_reader :title, :sections

      class Section
        attr_reader   :key
        attr_writer   :contents
        attr_accessor :sections

        def initialize(key)
          @key = key
        end

        def title
          @key.split('-').map(&:capitalize).join(' ')
        end

        def contents
          @contents && @contents.read
        end

        def has_children?
          @sections && !@sections.empty?
        end

        def has_contents?
          !@contents.nil?
        end
      end

      def initialize(title, root)
        @title    = title
        @root     = root
        @sections = find_sections(root)
      end

      private

      def find_sections(root)
        Pathname(root).children.inject({}) do |sections, path|
          unless path.symlink?
            if path.file? && path.extname == '.md'
              filename = path.sub_ext('').basename.to_s.sub(/^[0-9]*[\_\-]?/, '')
              key      = filename.split(/[\_\- ]/).map(&:downcase).join('-')

              unless sections.has_key?(key)
                sections[key] = Section.new(key)
              end

              sections[key].contents = path
            elsif path.directory? && !path.basename.to_s.start_with?('.')
              dirname = path.basename.to_s.sub(/^[0-9]*[\_\-]?/, '')
              key     = dirname.split(/[\_\- ]/).map(&:downcase).join('-')

              unless sections.has_key?(key)
                sections[key] = Section.new(key)
              end

              sections[key].sections = find_sections(path)
            end
          end

          sections
        end
      end
    end
  end
end