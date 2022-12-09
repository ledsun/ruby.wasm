import { RubyVM } from "..";
import { EvaluatedScriptStack } from "./EvaluatedScriptStack";
import { loadScriptAsync } from "./loadScriptAsync";
import { defineRubyWasm } from "./defineRubyWasm";
import { define_require_relative_url } from "./define_require_relative_url";

export class RubyRunner {
  private _stack: EvaluatedScriptStack;

  constructor(vm: RubyVM) {
    this._stack = new EvaluatedScriptStack(vm);
    defineRubyWasm(this._stack);
    define_require_relative_url(vm);
  }

  async runRubyScriptsInHtml(vm: RubyVM) {
    const tags = document.querySelectorAll('script[type="text/ruby"]');

    // Get Ruby scripts in parallel.
    const promisingRubyScripts = Array.from(tags).map((tag) =>
      loadScriptAsync(tag)
    );

    // Run Ruby scripts sequentially.
    for await (const rubyScript of promisingRubyScripts) {
      if (rubyScript) {
        await this._stack.eval(rubyScript);
      }
    }
  }
}
