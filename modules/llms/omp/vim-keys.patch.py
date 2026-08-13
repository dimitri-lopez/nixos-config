#!/usr/bin/env python3
"""Apply the omp vim list-navigation keybindings patch to dist/cli.js.

Makes Ctrl+H/J/K/L behave like the four arrow keys when navigating lists in
the omp TUI, without touching the editor's text keys (Ctrl+J=newline,
Ctrl+K=kill-line, Ctrl+H=backspace, Ctrl+L=live-voice are unchanged).

Why this exists: omp re-copies its bundle from the nix store on every version
bump (see modules/llms.org -> llms.nix, home.activation.installOmpDeps and the
`omp` wrapper). A hand-edited ~/.local/share/omp/dist/cli.js is silently
wiped by that re-copy. This script is invoked by the wrapper and activation
right after each re-copy, so the patch survives upgrades. It is IDEMPOTENT:
if the patch is already present it no-ops (exit 0).

Anchor safety: every replacement below asserts its `old` text occurs EXACTLY
once in the target. On an omp version bump where the minified code drifts,
the script aborts loudly (non-zero exit) -- turning a silent feature loss
into a build/activation failure so the anchors get updated deliberately.

Usage:
    python3 vim-keys.patch.py [path/to/cli.js]
    (default target: ~/.local/share/omp/dist/cli.js)

Scope boundary: only *list navigation* surfaces are routed through the new
tui.select.left/right actions. Editor cursor/text keys are intentionally not
changed. The 11 horizontal sites are derived from the installed 17.2.10
bundle; plain `h`/`l` handling in slider contexts is left untouched.
"""
import sys
from pathlib import Path

DEFAULT_TARGET = Path.home() / ".local/share/omp/dist/cli.js"
TARGET = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_TARGET

# Marker for idempotency: the tui.select.left action added to TUI_KEYBINDINGS.
ALREADY_PATCHED_MARKER = '"tui.select.left":{defaultKeys:"left"'

# Step 2: add tui.select.left/right actions to TUI_KEYBINDINGS (the KR0 literal)
STEP2_OLD = '"tui.select.up":{defaultKeys:"up",description:"Move selection up"}'
STEP2_NEW = ('"tui.select.left":{defaultKeys:"left",description:"Move selection left"},'
             '"tui.select.right":{defaultKeys:"right",description:"Move selection right"},'
             '"tui.select.up":{defaultKeys:"up",description:"Move selection up"}')

# Step 3: the 11 horizontal sites. Each `old` must occur EXACTLY once.
SITES = [
    # 1 TabBar next/prevTab
    ('tabbar-next-prev',
     r'if(p0(n,"tab")||p0(n,"right"))return this.nextTab(),!0;if(p0(n,"shift+tab")||p0(n,"left"))return this.prevTab(),!0',
     r'if(p0(n,"tab")||p0(n,"right")||Tf().matches(n,"tui.select.right"))return this.nextTab(),!0;if(p0(n,"shift+tab")||p0(n,"left")||Tf().matches(n,"tui.select.left"))return this.prevTab(),!0'),
    # 2a hook-selector slider left
    ('hook-selector-left',
     r'p0(n,"left")||this.#a&&!this.#M()&&p0(n,"h")',
     r'p0(n,"left")||Tf().matches(n,"tui.select.left")||this.#a&&!this.#M()&&p0(n,"h")'),
    # 2b hook-selector slider right
    ('hook-selector-right',
     r'p0(n,"right")||this.#a&&!this.#M()&&p0(n,"l")',
     r'p0(n,"right")||Tf().matches(n,"tui.select.right")||this.#a&&!this.#M()&&p0(n,"l")'),
    # 3 model-hub scope/list focus
    ('modelhub-focus',
     r'if(p0(n,"left")){this.#a="scope";return}if(p0(n,"right")){',
     r'if(p0(n,"left")||Tf().matches(n,"tui.select.left")){this.#a="scope";return}if(p0(n,"right")||Tf().matches(n,"tui.select.right")){'),
    # 4 model-hub chips strip
    ('modelhub-chips',
     r'if(p0(n,"left")||p0(n,"up")||p0(n,"shift+tab")){i.index=(i.index-1+i.chips.length)%i.chips.length;return}if(p0(n,"right")||p0(n,"down")||p0(n,"tab")){i.index=(i.index+1',
     r'if(p0(n,"left")||Tf().matches(n,"tui.select.left")||p0(n,"up")||p0(n,"shift+tab")){i.index=(i.index-1+i.chips.length)%i.chips.length;return}if(p0(n,"right")||Tf().matches(n,"tui.select.right")||p0(n,"down")||p0(n,"tab")){i.index=(i.index+1'),
    # 5 settings-selector tab bar
    ('settings-tabbar',
     r'if(p0(n,"left")||p0(n,"right")){this.#n.handleInput(n);return}',
     r'if(p0(n,"left")||Tf().matches(n,"tui.select.left")||p0(n,"right")||Tf().matches(n,"tui.select.right")){this.#n.handleInput(n);return}'),
    # 6 handleTabSwitchKey helper (Tx0)
    ('tabswitch-helper',
     r'if(p0(n,"tab")||p0(n,"right"))return i(1),!0;if(p0(n,"shift+tab")||p0(n,"left"))return i(-1),!0;return!1',
     r'if(p0(n,"tab")||p0(n,"right")||Tf().matches(n,"tui.select.right"))return i(1),!0;if(p0(n,"shift+tab")||p0(n,"left")||Tf().matches(n,"tui.select.left"))return i(-1),!0;return!1'),
    # 7 tree-selector page up/down
    ('tree-selector-page',
     r'else if(ck(n)||p0(n,"left"))this.#h=Math.max(0,this.#h-this.maxVisibleLines);else if(Uk(n)||p0(n,"right"))this.#h=Math.min(this.#i.length-1,this.#h+this.maxVisibleLines)',
     r'else if(ck(n)||p0(n,"left")||Tf().matches(n,"tui.select.left"))this.#h=Math.max(0,this.#h-this.maxVisibleLines);else if(Uk(n)||p0(n,"right")||Tf().matches(n,"tui.select.right"))this.#h=Math.min(this.#i.length-1,this.#h+this.maxVisibleLines)'),
    # 8 plan-review-overlay slider (#i0)
    ('planreview-slider',
     r'let i=p0(n,"left")||this.#G!==void 0&&p0(n,"h"),h=p0(n,"right")||this.#G!==void 0&&p0(n,"l")',
     r'let i=p0(n,"left")||Tf().matches(n,"tui.select.left")||this.#G!==void 0&&p0(n,"h"),h=p0(n,"right")||Tf().matches(n,"tui.select.right")||this.#G!==void 0&&p0(n,"l")'),
    # 9 plan-review-overlay ToC (#U0)
    # NOTE: the minified bundle contains a REAL newline byte inside the
    # template literal (n===`\n`) -- hence explicit '\n' concatenation.
    ('planreview-toc',
     r'if(p0(n,"left")||p0(n,"h")){if(this.#z)this.#L("toc");return}if(p0(n,"right")||p0(n,"l")||p0(n,"enter")||p0(n,"return")||n===`' + '\n' + r'`)',
     r'if(p0(n,"left")||Tf().matches(n,"tui.select.left")||p0(n,"h")){if(this.#z)this.#L("toc");return}if(p0(n,"right")||Tf().matches(n,"tui.select.right")||p0(n,"l")||p0(n,"enter")||p0(n,"return")||n===`' + '\n' + r'`)'),
    # 10 agent-hub details close
    ('agenthub-details-close',
     r'if(p0(n,"left")){if(this.#y&&!this.#K){this.#y=!1,this.#o();ret',
     r'if(p0(n,"left")||Tf().matches(n,"tui.select.left")){if(this.#y&&!this.#K){this.#y=!1,this.#o();ret'),
    # 11a log-viewer collapse
    ('logviewer-collapse',
     r'if(p0(n,"left")){this.#c=void 0,this.#n.collapseSelected();ret',
     r'if(p0(n,"left")||Tf().matches(n,"tui.select.left")){this.#c=void 0,this.#n.collapseSelected();ret'),
    # 11b log-viewer expand / load-older
    ('logviewer-expand',
     r'if(p0(n,"right")){if(this.#c=void 0,this.#n.cursorRowKind==="lo',
     r'if(p0(n,"right")||Tf().matches(n,"tui.select.right")){if(this.#c=void 0,this.#n.cursorRowKind==="lo'),
]


def apply(data):
    pairs = [("step2-actions", STEP2_OLD, STEP2_NEW)] + SITES
    ok = 0
    for name, old, new in pairs:
        n = data.count(old)
        if n != 1:
            print(f"ABORT: '{name}' matched {n} times (expected exactly 1) "
                  f"in {TARGET}", file=sys.stderr)
            sys.exit(1)
        data = data.replace(old, new)
        ok += 1
    return data, ok


def main():
    if not TARGET.exists():
        print(f"ERROR: {TARGET} not found", file=sys.stderr)
        sys.exit(1)
    data = TARGET.read_text()
    if ALREADY_PATCHED_MARKER in data:
        print(f"already patched: {TARGET} (no-op)")
        return 0
    patched, ok = apply(data)
    TARGET.write_text(patched)
    print(f"patched {TARGET}: {ok}/{ok} ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
