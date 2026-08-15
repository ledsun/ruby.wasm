import { readFileSync } from "node:fs";
import { WASI } from "wasi";
import { RubyVM } from "./vm.js";

const installRequireLocalBridge = () => {
  globalThis.__ruby_wasm_require_local__ = {
    read_file(path: string) {
      return readFileSync(path, "utf8");
    },
  };
};

export const DefaultRubyVM = async (
  rubyModule: WebAssembly.Module,
  options: { env?: Record<string, string> | undefined } = {},
) => {
  const wasi = new WASI({ env: options.env, version: "preview1", returnOnExit: true });
  const { vm, instance } = await RubyVM.instantiateModule({ module: rubyModule, wasip1: wasi });
  installRequireLocalBridge();

  return {
    vm,
    wasi,
    instance,
  };
};
