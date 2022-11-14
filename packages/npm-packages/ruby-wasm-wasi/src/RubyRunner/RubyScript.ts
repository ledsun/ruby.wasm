import { EvaluatedScriptStack } from "./EvaluatedScriptStack";

export class RubyScript {
  private _url: URL;
  private _scriptBody: string;

  constructor(url: URL, scriptBody: string) {
    this._url = url;
    this._scriptBody = scriptBody;
  }

  get ScriptBody() {
    return this._scriptBody;
  }

  get URL() {
    return this._url;
  }
}
