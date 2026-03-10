import { readFileSync } from "node:fs";
import { WASI } from "wasi";
import { RbValue, RubyVM } from "./vm.js";

export type NodeRubyVM = RubyVM & {
  evalFile(path: string): RbValue;
};

export const evalRubyFile = (vm: RubyVM, path: string): RbValue => {
  const code = readFileSync(path, "utf8");
  return vm.eval(code, { filename: path });
};

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
  const nodeVm = vm as NodeRubyVM;
  installRequireLocalBridge();
  nodeVm.evalFile = (path: string) => evalRubyFile(vm, path);

  return {
    vm: nodeVm,
    wasi,
    instance,
  };
};
