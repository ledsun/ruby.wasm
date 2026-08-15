module JS
  # The bundled local and remote shims are intended to be used exclusively;
  # only one loader is expected to be installed. Applications that need to
  # resolve require_relative from both local and remote sources should define
  # their own shim with application-specific fallback rules instead of loading
  # both bundled shims.
  module RequireRelativeShim
    def self.install(loader)
      Kernel.module_eval do
        alias original_require_relative require_relative

        define_method(:require_relative) do |path|
          caller_path = caller_locations(1, 1).first.absolute_path || ""
          dir = File.dirname(caller_path)
          file = File.absolute_path(path, dir)

          original_require_relative(file)
        rescue LoadError
          loader.load(path)
        end
      end
    end
  end
end
