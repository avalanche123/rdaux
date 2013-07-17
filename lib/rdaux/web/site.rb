module RDaux
  module Web
    class Site
      attr_reader :title, :description, :author, :root

      class Section
        attr_reader   :key
        attr_writer   :contents
        attr_accessor :sections

        def initialize(key)
          @key = key
        end

        def title
          @title ||= @key.split('-').map(&:capitalize).join(' ')
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

      def initialize(title, description, author, root)
        @title       = title
        @description = description
        @author      = author
        @root        = root
      end

      def sections
        find_sections(@root)
      end

      private

      def find_sections(root)
        root.children.inject({}) do |sections, path|
          unless path.symlink?
            if path.file? && path.extname == '.md'
              key = basename_to_key(base_filename(path))
              section = get_or_create_section(key, sections)

              section.contents = path
            elsif path.directory? && !path.basename.to_s.start_with?('.')
              key = basename_to_key(base_dirname(path))
              section = get_or_create_section(key, sections)

              section.sections = find_sections(path)
            end
          end

          sections
        end
      end

      def get_or_create_section(key, sections)
        unless sections.has_key?(key)
          sections[key] = Section.new(key)
        end

        sections[key]
      end

      def basename_to_key(basename)
        basename.split(/[\_\- ]/).map(&:downcase).join('-')
      end

      def base_filename(path)
        path.sub_ext('').basename.to_s.sub(/^[0-9]*[\_\-]?/, '')
      end

      def base_dirname(path)
        path.basename.to_s.sub(/^[0-9]*[\_\-]?/, '')
      end
    end
  end
end