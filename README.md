<!-- BEGIN fragment: 01-header.md -->

# NixOS Shimboot Config

Personal ChromeOS desktop configuration for [nixos-shimboot](https://github.com/PopCat19/nixos-shimboot).

<!-- END fragment: 01-header.md -->
<!-- BEGIN fragment: 02-introduction.md -->
<details>
<summary>What is this?</summary>

This repo contains desktop configurations that layer on top of nixos-shimboot — a NixOS-based derivative of [ading2210/shimboot](https://github.com/ading2210/shimboot).

### shimboot vs nixos-shimboot

**shimboot** ([ading2210/shimboot](https://github.com/ading2210/shimboot)) is the original project — a collection of Python/bash scripts that patch a ChromeOS RMA shim to boot a standard Linux distribution (Debian by default). It uses `build_complete.sh`, `patch_rootfs.sh`, and `build.sh` to construct disk images.

**nixos-shimboot** ([PopCat19/nixos-shimboot](https://github.com/PopCat19/nixos-shimboot)) is a derivative that replaces shimboot's Debian rootfs building with NixOS flake-based image generation. It uses the NixOS module system for declarative configuration, `raw-efi` image building via nixpkgs, and a patched systemd for ChromeOS kernel compatibility.

nixos-shimboot provides:
- ChromeOS hardware abstraction (boot, filesystem, kernel params)
- Patched systemd for ChromeOS kernel compatibility
- Helper scripts (expand-rootfs, setup-nixos, bwrap workarounds)
- Fish shell functions and abbreviations (nrb, cdn, etc.)
- Base system modules (networking, audio, hyprland, users)

This repo provides everything else: desktop environment, applications, theming, and Home Manager dotfiles.

</details>
<!-- END fragment: 02-introduction.md -->
<!-- BEGIN fragment: 03-structure.md -->
<details>
<summary>Structure</summary>

```
nixos-shimboot-config/
├── flake.nix           # imports nixos-shimboot as flake input
├── flake.lock
├── configuration.nix   # system configuration entry point
├── system/             # NixOS system modules
└── home/               # Home Manager modules
```

</details>
<!-- END fragment: 03-structure.md -->
<!-- BEGIN fragment: 04-quickstart.md -->

## Quick Start

### Prerequisites

- NixOS system with flakes enabled
- A Chromebook compatible with shimboot
- The nixos-shimboot repo (imported as a flake input)

### Build and Switch

```bash
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config

# Full system rebuild (NixOS + Home Manager as a NixOS module)
sudo nixos-rebuild switch --flake .#nixos-shimboot
```

Home Manager is configured as a NixOS module. There is no standalone `home-manager switch` command. All dotfile changes are applied via `nixos-rebuild switch`.

### Fork This Config

1. Fork this repo
2. Customize `configuration.nix`, `system/`, and `home/`
3. Update `flake-modules/nixos.nix` with your preferred `username`
4. Build with `sudo nixos-rebuild switch --flake .#nixos-shimboot`

<!-- END fragment: 04-quickstart.md -->
<!-- BEGIN fragment: 05-architecture.md -->
<details>
<summary>Architecture</summary>

This repo imports nixos-shimboot as a hardware module:

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

# In nixosConfigurations:
modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw)
  ./configuration.nix               # personal config (DE, packages, HM)
];
```

nixos-shimboot's `mkForce` declarations handle ChromeOS-specific constraints (initScript boot, single-partition layout). Personal config handles everything else — DE, packages, theming, services.

</details>
<!-- END fragment: 05-architecture.md -->
<!-- BEGIN fragment: 06-workarounds.md -->
<details>
<summary>Shimboot-Specific Workarounds</summary>

nixos-shimboot includes several workarounds inherited from shimboot's ChromeOS kernel limitations:

| Workaround | Origin | Purpose |
|------------|--------|---------|
| `systemd-patch` | shimboot | Patches systemd to handle ChromeOS kernel mount complaints |
| `bwrap-wrapper` | shimboot | Works around ChromeOS LSM restrictions on bubblewrap |
| `expand-rootfs` | shimboot | Expands rootfs to full USB drive on first boot |
| `setup-nixos` | nixos-shimboot | Interactive first-boot setup helper |
| `kill-frecon` | shimboot | Disables ChromeOS frecon to allow graphics |

</details>
<!-- END fragment: 06-workarounds.md -->
<!-- BEGIN fragment: 07-configuration.md -->
<details>
<summary>Configuration Options</summary>

### nixos-shimboot Fish Shell

nixos-shimboot includes fish functions and abbreviations by default. Opt-out options:

```nix
# Disable all nixos-shimboot fish config
shimboot.fish.enable = false;

# Keep fish enabled but skip function installation
shimboot.fish.enableFunctions = false;

# Keep functions but skip abbreviations
shimboot.fish.enableAbbreviations = false;
```

Core abbreviations `nrb` (nixos-rebuild-basic) and `cdn` (cd to config dir) are always installed. They can be remapped in your own fish config.

### Module Paths

| Path | Purpose |
|------|---------|
| `configuration.nix` | System configuration entry point |
| `system/` | NixOS system modules (services, packages, theming) |
| `home/` | Home Manager modules (dotfiles, apps, hyprland config) |

</details>
<!-- END fragment: 07-configuration.md -->
<!-- BEGIN fragment: 08-limitations.md -->
<details>
<summary>Known Limitations</summary>

- Desktop config requires nixos-shimboot as a flake input
- ChromeOS kernel limitations apply (no suspend, limited audio) — inherited from shimboot
- Some Home Manager modules may require specific package versions
- `nixos-rebuild` may require `--option sandbox false` on shim kernels <5.6

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).

</details>
<!-- END fragment: 08-limitations.md -->
<!-- BEGIN fragment: context.md -->

# Context

- `01-header.md` — Repository title and high-level purpose
- `02-introduction.md` — Detailed explanation of the project context and shimboot relationship
- `03-structure.md` — Directory structure and component mapping
- `04-quickstart.md` — Essential commands for cloning and building
- `05-architecture.md` — Internal architecture and shimboot integration
- `06-workarounds.md` — Documentation of ChromeOS-specific kernel workarounds
- `07-configuration.md` — User-configurable options and module paths
- `08-limitations.md` — Known issues and fleet-wide constraints

<!-- END fragment: context.md -->

<!-- generated: 20260515-cc6f4a2 -->
