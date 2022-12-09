import { RubyScript } from "./RubyScript";
import { EvaluatedScriptStack } from "./EvaluatedScriptStack";

class RubyWasm {
  private _loadedPathes: Set<string> = new Set();
  private _stack: EvaluatedScriptStack;

  constructor(stack: EvaluatedScriptStack) {
    this._stack = stack;
  }

  async requireRelativeURL(relative_feature): Promise<boolean> {
    const filename = relative_feature.endsWith(".rb")
      ? relative_feature
      : `${relative_feature}.rb`;
    const url = new URL(filename, this._stack.currentURL);

    // Prevents multiple loading.
    if (this._loadedPathes.has(url.pathname)) {
      return false;
    }

    const response = await fetch(url);
    if (!response.ok) {
      return false;
    }

    const text = await response.text();
    await this._stack.eval(new RubyScript(url, text));

    return true;
  }
}

export function defineRubyWasm(stack: EvaluatedScriptStack): void {
  const loadedPathes: Set<string> = new Set();

  const global = window as any;
  global.rubyWasm = new RubyWasm(stack);
}
