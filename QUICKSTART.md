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
nix.settings.max-jobs = 1;
```
Serializes builds — prevents multiple compilers competing for RAM.

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).