import { RubyScript } from "./RubyScript";
import { EvaluatedScriptStack } from "./EvaluatedScriptStack";

export async function loadScriptAsync(tag: Element): Promise<RubyScript> {
  // Inline comments can be written with the src attribute of the script tag.
  // The presence of the src attribute is checked before the presence of the inline.
  // see: https://html.spec.whatwg.org/multipage/scripting.html#inline-documentation-for-external-scripts
  if (tag.hasAttribute("src")) {
    const url = new URL(tag.getAttribute("src"), location.href);
    const response = await fetch(url);

    if (response.ok) {
      return Promise.resolve(new RubyScript(url, await response.text()));
    }

    // Failure to load a script tag is not an exception that occurs in Ruby script.
    // Simply skip execution.
    return Promise.resolve(null);
  }

  if (!tag.innerHTML) {
    return Promise.resolve(null);
  }

  return Promise.resolve(new RubyScript(new URL(location.href), tag.innerHTML));
}
