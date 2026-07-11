#!/usr/bin/env python3
"""manifest.py - Generate manifest.json for agent navigation.

Scans .org files for :tangle directives, reads flake.nix for active WM,
and writes a structured manifest that agents can consume instead of
parsing the monolithic org source.
"""
import json, pathlib, re

BASE = pathlib.Path(__file__).parent


def find_tangle_targets(org_path):
    """Return list of .nix files that an .org file generates."""
    text = org_path.read_text()
    targets = set()
    for m in re.finditer(r':tangle\s+(\S+)', text):
        t = m.group(1)
        if t.lower() != 'no' and t.endswith('.nix'):
            targets.add(t)
    return sorted(targets)


def get_active_wm():
    """Parse per-host configs for assigned WMs."""
    wms = {}
    for host_org in sorted((BASE / 'hosts').rglob('default.org')):
        text = host_org.read_text()
        wms[host_org.parent.name] = "driftwm" if "driftwm" in text else "unknown"
    return wms


def get_available_wms():
    """Return the list of WMs found in per-host configs."""
    return sorted(set(get_active_wm().values()))


def main():
    files = {}
    for org in sorted(BASE.rglob('*.org')):
        if org.name == 'readme.org':
            # readme.org itself generates flake.nix + coordinates includes
            targets = find_tangle_targets(org)
            files[str(org.relative_to(BASE))] = {
                "generates": targets,
                "description": "Master config, flake.nix, includes"
            }
        else:
            targets = find_tangle_targets(org)
            if targets:
                files[str(org.relative_to(BASE))] = {
                    "generates": targets,
                    "description": f"Generates {len(targets)} file(s)"
                }

    manifest = {
        "version": "1",
        "source_of_truth": "org",
        "tangle_command": "python3 tangle.py readme.org",
        "sync_command": "./sync.sh",
        "window_managers": get_active_wm(),
        "files": files,
        "rules": {
            "edit_org_only": True,
            "nix_read_only": True,
            "exceptions": ["hardware-configuration.nix"]
        }
    }

    out = BASE / 'manifest.json'
    out.write_text(json.dumps(manifest, indent=2) + '\n')
    print(f"Generated: {out}")


if __name__ == '__main__':
    main()
