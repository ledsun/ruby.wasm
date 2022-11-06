import { loadScriptAsync } from "./loadScriptAsync";

export async function runRubyScriptsInHtml(vm) {
  const tags = document.querySelectorAll('script[type="text/ruby"]');

  // Get Ruby scripts in parallel.
  const promisingRubyScripts = Array.from(tags).map((tag) =>
    loadScriptAsync(tag)
  );

  // Run Ruby scripts sequentially.
  for await (const rubyScript of promisingRubyScripts) {
    if (rubyScript) {
      vm.eval(rubyScript);
    }
  }
}
