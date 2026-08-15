require "singleton"
require "js"
require_relative "./ruby_loader"
require_relative "./require_local/path_resolver"

module JS
  # This class loads Ruby scripts from the Node.js host filesystem.
  # RequireLocal must be explicitly enabled when creating DefaultRubyVM.
  #
  #   const { vm } = await DefaultRubyVM(rubyModule, {
  #     enableRequireLocal: true,
  #   });
  #
  # The host filesystem bridge uses the Node.js process permissions and is not
  # restricted by WASI preopens. Enable it only when the Ruby code is trusted.
  #
  # == Example
  #
  #   require "js/require_local"
  #   JS::RequireLocal.instance.base_dir = "/path/to/app"
  #   JS::RequireLocal.instance.load("main")
  #
  # This class is intended to support Kernel#require_relative for application
  # source code. Load the included shim to fall back to RequireLocal when the
  # original require_relative cannot load a file.
  #
  # == Example
  #
  #   require "js/require_local/relative_shim"
  #   JS::RequireLocal.instance.base_dir = "/path/to/app"
  #   require_relative "main"
  #
  class RequireLocal
    include Singleton

    def initialize
      @bridge = JS.global[:__ruby_wasm_require_local__]
      if @bridge == JS::Undefined || @bridge == JS::Null
        raise LoadError, "js/require_local is not enabled; pass enableRequireLocal: true to DefaultRubyVM"
      end

      @resolver = PathResolver.new(default_base_dir)
      @loader = RubyLoader.new
    end

    # Change the base directory used to resolve features. The default is the
    # current working directory of the Node.js process.
    def base_dir=(base_dir)
      @resolver = PathResolver.new(File.expand_path(base_dir.to_s, default_base_dir))
    end

    # Load a feature relative to the current base directory. Returns true when
    # the file is loaded, or false when it has already been loaded.
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
