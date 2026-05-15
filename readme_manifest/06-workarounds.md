nixos-shimboot includes several workarounds inherited from shimboot's ChromeOS kernel limitations:

| Workaround | Origin | Purpose |
|------------|--------|---------|
| `systemd-patch` | shimboot | Patches systemd to handle ChromeOS kernel mount complaints |
| `bwrap-wrapper` | shimboot | Works around ChromeOS LSM restrictions on bubblewrap |
| `expand-rootfs` | shimboot | Expands rootfs to full USB drive on first boot |
| `setup-nixos` | nixos-shimboot | Interactive first-boot setup helper |
| `kill-frecon` | shimboot | Disables ChromeOS frecon to allow graphics |
