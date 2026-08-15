require "singleton"
require "js"
require_relative "./ruby_loader"
require_relative "./require_local/path_resolver"

module JS
  class RequireLocal
    include Singleton

    def initialize
      @bridge = JS.global[:__ruby_wasm_require_local__]
      if @bridge == JS::Undefined || @bridge == JS::Null
        raise LoadError, "js/require_local is only supported on Node.js DefaultRubyVM"
      end

      @resolver = PathResolver.new(default_base_dir)
      @loader = RubyLoader.new
    end

    def base_dir=(base_dir)
      @resolver = PathResolver.new(File.expand_path(base_dir.to_s, default_base_dir))
    end

    def load(relative_feature)
      location = @resolver.get_location(relative_feature)
      return false if @loader.loaded?(location.path)

      code = read_file(location.path)
      load_code(code, location.path)
    end

    private

    def default_base_dir
      process = JS.global[:process]
      process.cwd.to_s
    end

    def read_file(path)
      @bridge.read_file(path).to_s
    rescue => e
      raise LoadError, "cannot load such file -- #{path}: #{e.message}"
    end

    def load_code(code, path)
      @resolver.push(path)
      @loader.load(code, path, path)
    ensure
      @resolver.pop
    end
  end
end
