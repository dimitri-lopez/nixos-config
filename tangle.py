#!/usr/bin/env python3
"""tangle.py - Org-babel tangle without Emacs.

Handles:
  - #+INCLUDE expansion (recursive)
  - :tangle path (skip if "no")
  - :noweb-ref blocks
  - :noweb yes expansion of <<name>> references
  - Basic property inheritance from heading drawers
  - Creates parent directories as needed

Usage:
  python3 tangle.py readme.org
"""
import re, sys, pathlib

INCLUDE_RE = re.compile(r'^#\+INCLUDE:\s+(.+?)\s*$', re.MULTILINE)
BLOCK_RE = re.compile(
    r'#\+begin_src\s+\S+(?P<hdr>.*?)\n(?P<body>.*?)\n#\+end_src',
    re.DOTALL)
PROPERTY_RE = re.compile(r'^:PROPERTIES:\s*$\n(.*?)^:END:\s*$', re.DOTALL | re.MULTILINE)
HEADER_ARGS_RE = re.compile(r':header-args(?:\:\w+)?:\s+(.+)$', re.MULTILINE)


def read_org(path, visited=None):
    """Read an org file, expanding #+INCLUDE directives recursively."""
    path = pathlib.Path(path).resolve()
    if visited is None:
        visited = set()
    if path in visited:
        return ""
    visited.add(path)
    text = path.read_text()
    return INCLUDE_RE.sub(
        lambda m: read_org(path.parent / m.group(1).strip().strip('"\''), visited),
        text)


def extract_heading_properties(text):
    """Build a dict mapping line numbers to inherited header-args from headings."""
    lines = text.split('\n')
    inherited = {}  # line -> header-args string
    current_stack = []
    
    for i, line in enumerate(lines):
        m = re.match(r'^(\*+)\s+', line)
        if m:
            level = len(m.group(1))
            # Pop stack to current level
            while current_stack and current_stack[-1][0] >= level:
                current_stack.pop()
            # Check for property drawer in next few lines
            props = ""
            for j in range(i+1, min(i+10, len(lines))):
                if lines[j].strip() == ':PROPERTIES:':
                    # Collect until :END:
                    for k in range(j+1, min(j+50, len(lines))):
                        if lines[k].strip() == ':END:':
                            block = '\n'.join(lines[j+1:k])
                            ha = HEADER_ARGS_RE.search(block)
                            if ha:
                                props = ha.group(1).strip()
                            break
                    break
            current_stack.append((level, props))
        
        # Build inherited args for this line from current stack
        args = []
        for _, p in current_stack:
            if p:
                args.append(p)
        if args:
            inherited[i] = ' '.join(args)
    
    return inherited


def collect_refs(text, inherited):
    """Collect all :noweb-ref blocks into a dict {name: body}.
    Multiple blocks with the same ref name are concatenated.
    Strips common indentation from each ref body (org-babel behavior).
    Explicit block-level :noweb-ref overrides inherited property."""
    refs = {}
    lines = text.split('\n')
    for m in BLOCK_RE.finditer(text):
        hdr = m.group('hdr')
        start_line = text[:m.start()].count('\n')
        # Block-level :noweb-ref overrides inherited
        match = re.search(r':noweb-ref\s+(\S+)', hdr)
        if not match and start_line in inherited:
            match = re.search(r':noweb-ref\s+(\S+)', inherited[start_line])
        if match:
            name = match.group(1)
            body = strip_common_indent(m.group('body'))
            if name in refs:
                refs[name] += '\n' + body
            else:
                refs[name] = body
    return refs


def strip_common_indent(text):
    """Strip common leading whitespace from all lines (org-babel behavior)."""
    lines = text.split('\n')
    # Find minimum indentation among non-empty lines
    indents = [len(line) - len(line.lstrip()) for line in lines if line.strip()]
    if not indents or min(indents) == 0:
        return text
    min_indent = min(indents)
    return '\n'.join(
        line[min_indent:] if line.strip() else line
        for line in lines
    )


def expand(body, refs, seen=None):
    """Recursively expand <<name>> references using refs dict.
    Preserves indentation of the reference line."""
    if seen is None:
        seen = set()

    def repl(m):
        name = m.group(1)
        if name in seen:
            return f"<<{name}>>"
        seen.add(name)
        ref_body = expand(refs.get(name, m.group(0)), refs, seen.copy())
        # Find indentation of the line containing the reference
        line_start = body.rfind('\n', 0, m.start())
        if line_start == -1:
            line_start = 0
        else:
            line_start += 1
        indent = body[line_start:m.start()]
        # Indent each non-empty line of the ref body
        lines = ref_body.split('\n')
        indented = lines[0]
        for line in lines[1:]:
            if line.strip():
                indented += '\n' + indent + line
            else:
                indented += '\n'
        return indented

    return re.sub(r'<<([^>]+)>>', repl, body)


def tangle(text, base):
    """Tangle all src blocks in the expanded text."""
    inherited = extract_heading_properties(text)
    refs = collect_refs(text, inherited)
    for m in BLOCK_RE.finditer(text):
        hdr = m.group('hdr')
        start_line = text[:m.start()].count('\n')
        # Build effective header from block + inherited properties
        effective_hdr = hdr
        if start_line in inherited:
            effective_hdr = inherited[start_line] + ' ' + effective_hdr
        tangle_match = re.search(r':tangle\s+(\S+)', effective_hdr)
        if not tangle_match or tangle_match.group(1).lower() == 'no':
            continue
        body = m.group('body')
        body = strip_common_indent(body)
        if ':noweb yes' in effective_hdr:
            body = expand(body, refs)
            # Strip again after expansion to match org-babel behavior
            body = strip_common_indent(body)
        out = base / tangle_match.group(1)
        out.parent.mkdir(parents=True, exist_ok=True)
        # Unlock if read-only (generated .nix files are typically 444)
        was_readonly = False
        if out.exists() and not out.stat().st_mode & 0o200:
            out.chmod(0o644)
            was_readonly = True
        out.write_text(body.rstrip() + '\n')
        if was_readonly:
            out.chmod(0o444)
        print(f"Tangled: {out}")


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <master.org>")
        sys.exit(1)
    master = pathlib.Path(sys.argv[1]).resolve()
    base = master.parent
    text = read_org(master)
    tangle(text, base)


if __name__ == '__main__':
    main()
