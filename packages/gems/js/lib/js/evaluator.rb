module JS
  module Evaluator
    module_function

    def evaluate(code, filename)
      Kernel.eval(code.to_s, ::Object::TOPLEVEL_BINDING, filename.to_s)
    end
  end
end
