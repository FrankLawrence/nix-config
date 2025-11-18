# Quick Reference Guide

## Common Commands

### Building and Switching

```bash
# Build system configuration (don't switch)
sudo nixos-rebuild build --flake .#hostname

# Switch system configuration
sudo nixos-rebuild switch --flake .#hostname

# Test configuration (reverts on reboot)
sudo nixos-rebuild test --flake .#hostname

# Build home-manager configuration
home-manager build --flake .#username

# Switch home-manager configuration
home-manager switch --flake .#username

# Update flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Secrets Management

```bash
# Edit a secret
agenix -e secrets/mysecret.age

# Create a new secret
agenix -e secrets/newsecret.age

# Rekey all secrets (after adding new SSH keys)
cd secrets && agenix --rekey
```

### Maintenance

```bash
# Garbage collect old generations
nix-collect-garbage -d

# Remove old boot entries (keep last 5)
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5

# Optimize nix store
nix-store --optimize

# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# List home-manager generations
home-manager generations
```

### Debugging

```bash
# Show what would be built
nix build .#nixosConfigurations.hostname.config.system.build.toplevel --dry-run

# Show dependency tree
nix-store --query --tree /run/current-system

# Check service status
systemctl status service-name

# View service logs
journalctl -u service-name -f

# Show recent boot messages
journalctl -b
```

## File Locations

### System Configuration
```
/etc/nixos/               # Your config repo
├── flake.nix             # Main entry point
├── hosts/                # Host-specific configs
├── modules/              # System modules
└── secrets/              # Encrypted secrets
```

### Home Manager Configuration
```
~/.config/home-manager/   # Symlinked by home-manager
~/.local/state/home-manager/  # Generations
```

### Runtime
```
/run/current-system/      # Active system configuration
/run/user/1000/           # User runtime directory
/run/agenix/              # Decrypted secrets
```

## Adding New Things

### Add a New Service

1. Create module: `modules/services/category/myservice.nix`
```nix
{ config, lib, pkgs, ... }:
{
  services.myservice = {
    enable = true;
    # ... configuration
  };
}
```

2. Add to category's default.nix: `modules/services/category/default.nix`
```nix
{
  imports = [
    ./myservice.nix
  ];
}
```

3. Import in host if needed (or rely on category import)

### Add a New Host

1. Create directory: `hosts/newhostname/`
2. Generate hardware config:
```bash
nixos-generate-config --show-hardware-config > hosts/newhostname/hardware-configuration.nix
```

3. Create `hosts/newhostname/default.nix`:
```nix
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "newhostname";
  # ... host-specific settings
}
```

4. Add to flake.nix:
```nix
nixosConfigurations.newhostname = mkSystem "newhostname" [
  # modules this host needs
];
```

### Add a New User Program

1. Create module: `home/programs/category/myprogram.nix`
```nix
{ config, pkgs, ... }:
{
  programs.myprogram = {
    enable = true;
    # ... configuration
  };
}
```

2. Import in user profile: `home/profiles/username.nix`
```nix
{
  imports = [
    ../programs/category/myprogram.nix
  ];
}
```

### Add a New Secret

1. Create the secret:
```bash
agenix -e secrets/newsecret.age
```

2. Add to `secrets/secrets.nix`:
```nix
{
  "newsecret.age".publicKeys = users ++ systems;
}
```

3. Use in configuration:
```nix
age.secrets.newsecret = {
  file = ../secrets/newsecret.age;
  owner = "myuser";
  group = "mygroup";
};

# Reference in config
services.myservice.passwordFile = config.age.secrets.newsecret.path;
```

## Module Patterns

### Basic Module
```nix
{ config, lib, pkgs, ... }:
{
  # Configuration here
}
```

### Module with Options
```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.mymodule;
in
{
  options.mymodule = {
    enable = lib.mkEnableOption "my module";
    setting = lib.mkOption {
      type = lib.types.str;
      default = "default value";
      description = "A setting";
    };
  };

  config = lib.mkIf cfg.enable {
    # Configuration when enabled
  };
}
```

### Module with Defaults
```nix
{ config, lib, pkgs, ... }:
{
  # Can be overridden by host
  time.timeZone = lib.mkDefault "Europe/Zurich";
  
  # Forces the value, overrides everything
  networking.firewall.enable = lib.mkForce true;
}
```

## Directory Purpose

| Directory | Purpose | Level |
|-----------|---------|-------|
| `hosts/` | Host-specific configurations | System |
| `modules/core/` | Essential system settings | System |
| `modules/services/` | Self-hosted services | System |
| `modules/hardware/` | Hardware configurations | System |
| `modules/desktop/` | Desktop environments | System |
| `home/` | User configurations | User |
| `home/profiles/` | Per-user settings | User |
| `home/programs/` | Program configurations | User |
| `lib/` | Helper functions | Library |
| `secrets/` | Encrypted secrets | Data |

## Import Patterns

### Host Configuration
```nix
# hosts/jupiter/default.nix
{
  imports = [
    ./hardware-configuration.nix
    # Don't import modules here - do it in flake.nix
  ];
}
```

### Service Category
```nix
# modules/services/media/default.nix
{
  imports = [
    ./navidrome.nix
    ./kavita.nix
    ./komga.nix
  ];
}
```

### User Profile
```nix
# home/profiles/frank.nix
{
  imports = [
    ../default.nix
    ../programs/terminal/kitty.nix
    ../programs/terminal/tmux.nix
  ];
}
```

## Troubleshooting Quick Fixes

### Configuration doesn't apply
```bash
# Rebuild and check for errors
sudo nixos-rebuild switch --flake .#hostname --show-trace
```

### Service won't start
```bash
# Check service status and logs
systemctl status myservice
journalctl -u myservice -n 50
```

### Home-manager issues
```bash
# Clear cache and rebuild
rm -rf ~/.cache/nix
home-manager switch --flake .#username
```

### Secrets not decrypting
```bash
# Check age identity
ls -la /run/agenix/
# Verify SSH key
ssh-add -l
# Rekey secrets
cd secrets && agenix --rekey
```

### Build fails with "file not found"
```bash
# Check git status - untracked files aren't included
git status
git add .
```

## Performance Tips

1. **Use binary cache**: Speeds up builds significantly
```nix
nix.settings = {
  substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
};
```

2. **Enable parallel building**:
```nix
nix.settings = {
  max-jobs = "auto";
  cores = 0;  # Use all cores
};
```

3. **Regular garbage collection**:
```bash
# Add to your crontab or systemd timer
nix-collect-garbage --delete-older-than 30d
```

## Useful Nix Commands

```bash
# Search for packages
nix search nixpkgs firefox

# Run a package without installing
nix run nixpkgs#cowsay -- "Hello NixOS"

# Enter a shell with packages
nix shell nixpkgs#git nixpkgs#neovim

# Evaluate an expression
nix eval .#nixosConfigurations.jupiter.config.networking.hostName

# Show flake info
nix flake show
nix flake metadata
```
