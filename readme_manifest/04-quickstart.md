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
