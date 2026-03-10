module JS
  class RequireLocal
    class Evaluator
      def evaluate(code, path, loaded_feature)
        Kernel.eval(code, ::Object::TOPLEVEL_BINDING, path)
        $LOADED_FEATURES << loaded_feature
      end

      def evaluated?(path)
        $LOADED_FEATURES.include?(path)
      end
    end
  end
end
