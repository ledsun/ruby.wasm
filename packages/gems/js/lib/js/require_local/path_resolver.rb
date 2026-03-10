module JS
  class RequireLocal
    ScriptLocation = Data.define(:path, :filename)

    class PathResolver
      def initialize(base_dir)
        @path_stack = [File.expand_path(base_dir.to_s)]
      end

      def get_location(relative_feature)
        filename = filename_from(relative_feature)
        path = File.expand_path(filename, @path_stack.last)
        ScriptLocation.new(path, path)
      end

      def push(path)
        @path_stack.push File.dirname(path.to_s)
      end

      def pop
        @path_stack.pop
      end

      def inspect
        "#{self.class}(#{@path_stack})"
      end

      private

      def filename_from(relative_feature)
        feature = relative_feature.to_s
        feature.end_with?(".rb") ? feature : "#{feature}.rb"
      end
    end
  end
end
