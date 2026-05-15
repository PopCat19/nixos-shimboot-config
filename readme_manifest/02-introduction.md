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
