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

### 2. Choose Your Branch

- `popcat19`. . Personal desktop config (Hyprland, theming, applications)
- `main`. . Reference template for creating your own config

```bash
git checkout popcat19
```

### 3. Build and Switch

```bash
# Navigate to config dir (using nixos-shimboot's cdn abbreviation)
cdn

# Full system rebuild (NixOS + Home Manager as a NixOS module)
nrb
```

`nrb` is shorthand for `nixos-rebuild-basic`, a fish function provided by nixos-shimboot that handles the rebuild with appropriate flags.

### 4. First Boot

After flashing a nixos-shimboot image and booting into NixOS:

```bash
# Clone this repo on the running system
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
git checkout popcat19

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
   git checkout <your-branch>
   ```
4. Rebuild from root shell:
   ```bash
   sudo -i
   cd /home/nixos-user/nixos-shimboot-config
   nixos-rebuild switch --flake .#<hostname> --option sandbox false
   ```
5. Reboot
6. Rsync old home to new user:
   ```bash
   sudo rsync -av --ignore-existing --exclude='.cache' /home/nixos-user/ /home/<newuser>/
   sudo chown -R $(id -u <newuser>):$(id -g <newuser>) /home/<newuser>/
   ```

## Adding a New Profile

1. Create branch:
   ```bash
   git checkout main
   git checkout -b <name>
   ```
2. Copy `main/` as starting point:
   ```bash
   cp -r main/ <name>/
   ```
3. Add to `flake.nix`:
   ```nix
   profileUserConfigs = {
     main = mkUserConfig { username = "nixos-user"; };
     <name> = mkUserConfig { username = "<name>"; hostname = "<hostname>"; };
   };

   nixosConfigurations.<hostname> = mkConfig "<name>";
   ```
4. Add `.gitattributes` guard on your branch:
   ```bash
   echo '<name>/** merge=ours' >> .gitattributes
   echo 'flake.lock merge=theirs' >> .gitattributes
   git config merge.ours.driver true
   ```
5. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Flake Lock Rules

- Only update `flake.lock` on `main` branch
- Propagation CI carries lock updates to personal branches automatically
- Never update lock directly on personal branches : causes merge conflicts

```bash
git checkout main
nix flake update shimboot
git add flake.lock
git commit -m "chore: update shimboot input"
git push origin main
```

## How It Works

This repo imports nixos-shimboot as a hardware module:

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw)
  ./popcat19/configuration.nix     # personal config (DE, packages, HM)
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

## Migrating from nixos-shimboot (username change)

**Always rebuild from a root shell.** Active user sessions break when NixOS removes the old user mid-rebuild.

```bash
sudo -i
cd /home/nixos-user/nixos-shimboot-config
# use nrb if fish is available, handles kernel sandbox flags automatically
nrb
# fallback for kernels <5.6 without nrb:
# nixos-rebuild switch --flake .#<profile> --option sandbox false
```

After reboot, migrate home data manually:

```bash
sudo rsync -av --ignore-existing --exclude='.cache' /home/nixos-user/ /home/<newuser>/
sudo chown -R $(id -u <newuser>):$(id -g <newuser>) /home/<newuser>/
```

## Renaming hostname

1. Update `flake.nix`:
   - Set `hostname` in `profileUserConfigs`
   - Rename `nixosConfigurations.<attr>` to match new hostname

2. First rebuild requires explicit target (old hostname still active):
   ```bash
   sudo nixos-rebuild switch --flake .#<new-hostname>
   ```

3. After reboot `nrb` resolves automatically by hostname.

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
Hostname in `nixosConfigurations` doesn't match system hostname. Use explicit target:
```bash
sudo nixos-rebuild switch --flake .#<attr>
```

### NIXOS_CONFIG_DIR points to wrong directory
`environment.nix` not imported. Add to `<profile>/system/configuration.nix`:
```nix
imports = [ ./environment.nix ];
```

### OOM during rebuild
Add to shimboot `nix-options.nix`:
```nix
nix.settings.max-jobs = "1";
```
Serializes builds — prevents multiple compilers competing for RAM.

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).