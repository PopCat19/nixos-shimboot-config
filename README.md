# nixos-shimboot-config

Personal ChromeOS desktop configuration template for [nixos-shimboot](https://github.com/PopCat19/nixos-shimboot).

## What is this?

This repo layers desktop configuration on top of nixos-shimboot's ChromeOS hardware abstraction layer. nixos-shimboot handles ChromeOS-specific constraints (patched systemd, initScript boot, single-partition layout). This repo handles everything else — desktop environment, applications, theming, and Home Manager dotfiles.

## Branch Structure

- `main`: reference template. Fork this to create your own config
- Personal branches (e.g. `popcat19`): per-user desktop configs built on top of `main`

Personal branches stay in sync with `main` via automated propagation CI.

## Repository Layout

```
nixos-shimboot-config/
├── flake.nix           # imports nixos-shimboot as flake input
├── flake.lock
└── main/               # reference template
    ├── configuration.nix
    ├── system/         # NixOS modules (services, packages, theming)
    └── home/           # Home Manager modules (dotfiles, apps, WM config)
```

Personal branches add their own profile directory alongside `main/`:

```
├── main/               # inherited from main branch via propagation
└── <your-name>/:       personal profile
```

## Architecture

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw, patched systemd)
  ./<profile>/configuration.nix    # personal config (DE, packages, HM)
];
```

## Quick Start

See [QUICKSTART.md](QUICKSTART.md).

## nixos-shimboot Fish Functions

nixos-shimboot provides fish functions and abbreviations on all profiles:

| Function | Purpose |
|----------|---------|
| `nrb` | `nixos-rebuild switch` with kernel-appropriate flags |
| `cdn` | `cd` to `$NIXOS_CONFIG_DIR` |
| `cnup` | Lint, format, and validate flake (statix, deadnix, treefmt) |
| `nixos-flake-update` | Update flake inputs with lock diff and backup |

`NIXOS_CONFIG_DIR` is set to `$HOME/nixos-shimboot-config` by default.

## Shimboot-Specific Workarounds

Inherited from nixos-shimboot — no action needed:

| Workaround | Purpose |
|------------|---------|
| `systemd-patch` | Patches systemd for ChromeOS kernel mount compatibility |
| `bwrap-wrapper` | Works around ChromeOS LSM restrictions on bubblewrap |
| `expand-rootfs` | Expands rootfs to full USB drive on first boot |
| `kill-frecon` | Disables ChromeOS frecon to allow graphics |

## Binary Cache

Automatically configured via `shimboot.nixosModules.chromeos`. Provides cached patched systemd — no manual setup needed.

## Known Limitations

- ChromeOS kernel limitations apply (no suspend, limited audio)
- `nixos-rebuild` may require `--option sandbox false` on shim kernels <5.6 (handled automatically by `nrb`)

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).