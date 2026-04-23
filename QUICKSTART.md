# NixOS Shimboot Config Quickstart Guide

Personal ChromeOS desktop configuration for [nixos-shimboot](https://github.com/PopCat19/nixos-shimboot).

## Prerequisites

- NixOS system with flakes enabled
- A Chromebook compatible with shimboot
- The nixos-shimboot repo (imported automatically as a flake input)

## Quick Start

### 1. Clone and Enter the Repository

```bash
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
```

### 2. Build and Switch

```bash
# Navigate to config dir (using nixos-shimboot's cdn abbreviation)
cdn

# Full system rebuild (NixOS + Home Manager as a NixOS module)
nrb
```

`nrb` is shorthand for `nixos-rebuild-basic`, a fish function provided by nixos-shimboot that handles the rebuild with appropriate flags.

### 3. First Boot

After flashing a nixos-shimboot image and booting into NixOS:

```bash
# Clone this repo on the running system
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config

# Apply your config
nrb
```

## First Boot Checklist

1. Boot shimboot USB, login as `nixos-user`
2. Run base setup (WiFi, rootfs expansion, `/etc/nixos` wiring):
   ```bash
   setup-nixos
   ```
   Skip steps you've already completed with `--skip-wifi`, `--skip-expand`, etc.
3. Clone config repo:
   ```bash
   git clone https://github.com/PopCat19/nixos-shimboot-config.git
   cd nixos-shimboot-config
   ```
4. Rebuild from root shell:
   ```bash
   sudo -i
   cd /home/nixos-user/nixos-shimboot-config
   nixos-rebuild switch --flake .#nixos-shimboot0 --option sandbox false
   ```
5. Reboot

## How It Works

This repo imports nixos-shimboot as a hardware module:

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw)
  ./configuration.nix              # personal config (DE, packages, HM)
];
```

nixos-shimboot handles ChromeOS-specific constraints (initScript boot, single-partition layout, patched systemd). This repo handles everything else.

Home Manager is configured as a NixOS module. . There is no standalone `home-manager switch` command. All dotfile changes are applied via `nrb`.

## Building Shimboot Images

Building shimboot images requires Nix on Linux with sudo privileges (the assembly script uses loop mounts for partition manipulation). Docker/Podman builds are untested.

```bash
# Clone nixos-shimboot (the build system repo)
git clone https://github.com/PopCat19/nixos-shimboot.git
cd nixos-shimboot

# Build minimal image
sudo ./tools/build/assemble-final.sh --board dedede --rootfs minimal
```

## Troubleshooting

### Flake input out of date

```bash
nix flake update shimboot
```

### Build fails

```bash
# Check for syntax errors
nix flake check

# Rebuild full system
nrb
```

### nixos-shimboot module not found

Ensure the nixos-shimboot input is resolving correctly:

```bash
nix flake metadata
```

### nrb fails — hostname not found

Use explicit target:
```bash
sudo nixos-rebuild switch --flake .#nixos-shimboot0
```

### OOM during rebuild

Add to shimboot `nix-options.nix`:
```nix
nix.settings.max-jobs = "1";
```
Serializes builds — prevents multiple compilers competing for RAM.

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).