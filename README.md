# up

Perform an update on various linuxy systems and tools.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/projector22/up/master/src/install.sh | bash
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/projector22/up/master/src/uninstall.sh | bash
```

## Update Types Available

### Application Managers

- Apt & Nala (Apt frontend)
- DNF / Yum
- Pacman
- Snap
- Flatpak
- Pipx.

### Specific Applications

- [PiHole](https://github.com/pi-hole/pi-hole)
- [rclone](https://github.com/rclone/rclone)
- [Rust](https://github.com/rust-lang/rustup)
- [Linux New System](https://github.com/projector22/linux-new-system)

### Integration With NTFY

You can configre [NTFY](https://github.com/binwiederhier/ntfy) to notify you of a completed update.

## Todo

- Add flag to force Apt over Nala.
