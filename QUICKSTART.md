# nixos-shimboot-config Quickstart

## Prerequisites

- Chromebook booted into a nixos-shimboot image
- Flakes-enabled NixOS (provided by nixos-shimboot base config)

## 1. Clone the Repo

```bash
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
```

## 2. Choose a Branch

- `main`: reference template, minimal config
- Personal branch (e.g. `popcat19`): full desktop config

```bash
git checkout main      # or your personal branch
```

## 3. Rebuild

```bash
cdn    # cd to NIXOS_CONFIG_DIR
nrb    # nixos-rebuild switch with appropriate flags
```

`nrb` automatically handles kernel sandbox flags for shim kernels <5.6.

## Create Your Own Config

1. Fork this repo
2. Create a branch named after yourself (e.g. `alice`)
3. Copy `main/` as your profile starting point:
   ```bash
   cp -r main/ alice/
   ```
4. Add your profile to `flake.nix`:
   ```nix
   nixosConfigurations.alice = mkConfig "alice";
   ```
5. Customize `alice/configuration.nix`, `alice/system/`, `alice/home/`
6. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#alice
   ```

## Staying in Sync with main

Personal branches receive updates from `main` automatically via propagation CI on every push to `main`. No manual action needed.

To manually sync:
```bash
git checkout <your-branch>
git merge origin/main
```

## Building a Shimboot Image

Images are built from the nixos-shimboot repo, not this one:

```bash
git clone https://github.com/PopCat19/nixos-shimboot.git
cd nixos-shimboot
sudo ./tools/build/assemble-final.sh --board <board> --rootfs minimal
```

Supported boards: dedede, octopus, zork, nissa, hatch, grunt, snappy

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

## Troubleshooting

### Flake input out of date
```bash
nix flake update shimboot
git add flake.lock
git commit -m "chore: update shimboot input"
```

### Eval errors
```bash
nix eval .#nixosConfigurations.<profile>.config.system.build.toplevel
```

### shimboot module not resolving
```bash
nix flake metadata
```

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).