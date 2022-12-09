import { RubyVM } from "..";

export function define_require_relative_url(vm: RubyVM) {
  const script = `
  require "js"
  module Kernel
    def require_relative_url(relative_feature)
      JS.global[:rubyWasm].requireRelativeURL(relative_feature).await
    end
  end
  `;
  vm.eval(script);
}
