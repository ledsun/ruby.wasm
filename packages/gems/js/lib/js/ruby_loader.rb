module JS
  # This loader intentionally does not track features while they are being
  # evaluated, so recursive or circular loads are not supported. Although such
  # behavior would be problematic for general-purpose library loading, its
  # primary use here is to support the require_relative shim for application
  # source code. Application authors control those dependencies and are
  # expected to resolve any cycles themselves. We keep the loader simple until
  # there is a concrete need to support circular loading.
  class RubyLoader
    def load(code, filename, loaded_feature)
      Kernel.eval(code, ::Object::TOPLEVEL_BINDING, filename)
      $LOADED_FEATURES << loaded_feature
      true
    end

    def loaded?(loaded_feature)
      $LOADED_FEATURES.include?(loaded_feature)
    end
  end
end
