import { EvaluatedScriptStack } from "./EvaluatedScriptStack";

export class RubyScript {
  private _url: URL;
  private _scriptBody: string;

  constructor(url: URL, scriptBody: string) {
    this._url = url;
    const patchedScript = scriptBody.replace(
      /require_relative/g,
      "require_relative_url"
    );
    this._scriptBody = patchedScript;
  }

  get ScriptBody() {
    return this._scriptBody;
  }

  get URL() {
    return this._url;
  }
}
