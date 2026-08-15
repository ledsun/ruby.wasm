module JS
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
