- Desktop config requires nixos-shimboot as a flake input
- ChromeOS kernel limitations apply (no suspend, limited audio) — inherited from shimboot
- Some Home Manager modules may require specific package versions
- `nixos-rebuild` may require `--option sandbox false` on shim kernels <5.6

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).
