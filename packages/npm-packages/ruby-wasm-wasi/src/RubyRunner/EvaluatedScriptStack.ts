import { RubyScript } from "./RubyScript";

// To achieve require_relative, we need to resolve relative paths in Ruby scripts.
// Remember the URL of the running Ruby script.
export class EvaluatedScriptStack {
  private _vm;
  // Stores the URL of the running Ruby script to get the relative path from within the Ruby script.
  private _stack: Array<RubyScript>;

  constructor(vm) {
    this._vm = vm;
    this._stack = [];
  }

  async eval(script: RubyScript): Promise<void> {
    this._stack.push(script);
    await this._vm.evalAsync(script.ScriptBody);
    this._stack.pop();
  }
}
