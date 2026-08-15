require "js/require_local"
require "js/require_relative_shim"

JS::RequireRelativeShim.install(JS::RequireLocal.instance)
