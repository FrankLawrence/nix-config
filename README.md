# NixOS Configuration

A modular, multi-host NixOS configuration using flakes and home-manager.

## Directory Structure

```
nix-config/
├── flake.nix                 # Main flake entry point
├── flake.lock                # Locked dependencies
├── README.md                 # This file
│
├── hosts/                    # Host-specific configurations
│   ├── default.nix           # Shared host options
│   ├── andromeda/            # Hetzner Cloud VM
│   │   └── default.nix
│   ├── centauri/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── jupiter/
│       ├── default.nix
│       └── hardware-configuration.nix
│
├── modules/                  # Modular system configuration
│   ├── core/                 # Core system functionality
│   │   ├── default.nix
│   │   ├── boot.nix
│   │   ├── networking.nix
│   │   ├── nix.nix
│   │   ├── security.nix
│   │   └── users.nix
│   │
│   ├── services/             # Self-hosted services
│   │   ├── default.nix
│   │   ├── media/
│   │   │   ├── jellyfin.nix
│   │   │   ├── navidrome.nix
│   │   │   ├── kavita.nix
│   │   │   └── komga.nix
│   │   ├── productivity/
│   │   │   ├── mealie.nix
│   │   │   ├── paperless.nix
│   │   │   └── stirling-pdf.nix
│   │   ├── infrastructure/
│   │   │   ├── glance.nix
│   │   │   ├── pocket-id.nix
│   │   │   └── syncthing.nix
│   │   └── containers/
│   │       ├── mazanoke.nix
│   │       ├── omni-tools.nix
│   │       └── metadata-remote.nix
│   │
│   ├── hardware/             # Hardware-specific configs
│   │   ├── amd.nix
│   │   ├── bluetooth.nix
│   │   ├── audio.nix
│   │   └── nfs.nix
│   │
│   └── desktop/              # Desktop environment configs
│       ├── gnome.nix
│       ├── hyprland.nix
│       └── x11.nix
│
├── home/                     # Home Manager configurations
│   ├── default.nix           # Default home config
│   ├── profiles/             # User profiles
│   │   ├── frank.nix
│   │   └── pinkfloyd.nix
│   │
│   └── programs/             # Program-specific configs
│       ├── terminal/
│       │   ├── kitty.nix
│       │   ├── tmux.nix
│       │   └── shells/
│       │       ├── bash.nix
│       │       └── fish.nix
│       ├── editors/
│       │   ├── neovim.nix
│       │   └── emacs.nix
│       ├── browsers/
│       │   └── librewolf.nix
│       └── tools/
│           ├── git.nix
│           └── cli-tools.nix
│
├── lib/                      # Custom library functions
│   ├── default.nix
│   └── helpers.nix
│
└── secrets/                  # Age-encrypted secrets
    ├── secrets.nix
    └── *.age files
```

## Major Changes and Reasoning

### 1. **Separation of Concerns**

**Change**: Split configuration into distinct layers: `hosts/`, `modules/`, and `home/`

**Reasoning**: 
- **hosts/**: Contains host-specific configurations (networking, hardware)
- **modules/**: Contains reusable system-level modules
- **home/**: Contains user-level configurations managed by home-manager
- This separation makes it clear what operates at which level and prevents mixing concerns

### 2. **Categorized Modules**

**Change**: Organized modules into logical subdirectories:
- `core/` - Essential system functionality
- `services/` - Self-hosted applications (further categorized)
- `hardware/` - Hardware-specific configurations
- `desktop/` - Desktop environment configurations

**Reasoning**:
- Easier to navigate and find specific configurations
- Services are grouped by purpose (media, productivity, infrastructure)
- Reduces cognitive load when maintaining the config
- Follows the principle of "low coupling, high cohesion"

### 3. **Default.nix Aggregators**

**Change**: Each subdirectory has a `default.nix` that imports all modules in that directory

**Reasoning**:
- Simplifies imports in host configurations
- Instead of importing 10+ individual files, import one directory
- Easy to enable/disable entire categories of functionality
- Example: `imports = [ ../../modules/services ];` imports all services

### 4. **Home Manager Integration**

**Change**: Moved user-level configurations to dedicated `home/` directory with profiles

**Reasoning**:
- Home Manager configurations shouldn't be mixed with system configs
- User profiles allow different users to have different configurations
- Programs are organized by category (terminal, editors, browsers, tools)
- Easier to reuse configurations across different machines

### 5. **Host-Specific vs Shared Configuration**

**Change**: Created `hosts/default.nix` for shared host options

**Reasoning**:
- Common settings (timezone, locale, nix settings) defined once
- Each host imports the defaults and overrides as needed
- Reduces duplication across host configurations
- Makes it obvious what's unique to each host

### 6. **Service Organization by Purpose**

**Change**: Services split into `media/`, `productivity/`, `infrastructure/`, and `containers/`

**Reasoning**:
- Media services (Jellyfin, Navidrome, etc.) are logically grouped
- Easy to enable all media services on a media server
- Container-based services separated for clarity
- Each category can have its own defaults and shared options

### 7. **Program Modules are Self-Contained**

**Change**: Each program module is complete and doesn't depend on others

**Reasoning**:
- Modules can be imported independently
- No hidden dependencies between modules
- Easy to copy a single module to another configuration
- Clear what each module does without reading other files

### 8. **Lib Directory for Helpers**

**Change**: Created `lib/` directory for custom functions

**Reasoning**:
- Common functions don't pollute the main configuration
- Reusable helpers for repeated patterns
- Can include functions for:
  - Creating service users
  - Setting up reverse proxy rules
  - Managing secrets
  - Host-specific option generators

### 9. **Kitty with Tmux Integration**

**Change**: Kitty terminal configured to automatically start tmux

**Reasoning**:
- Single terminal instance with persistent sessions
- Configured via Home Manager for user-level management
- Uses shell integration for seamless experience
- Command: `kitty` automatically runs `tmux new-session -A -s Main`

### 10. **Consistent Module Pattern**

**Change**: All modules follow this pattern:
```nix
{ config, lib, pkgs, ... }:

{
  options = { ... };  # Optional: module-specific options
  config = { ... };   # Actual configuration
}
```

**Reasoning**:
- Predictable structure across all modules
- Easy to add options for customization later
- Follows NixOS module system best practices
- Makes modules composable and reusable

## Quick Start

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/FrankLawrence/nix-config.git /etc/nixos

# For new installations, generate hardware config
nixos-generate-config --show-hardware-config > hosts/newhostname/hardware-configuration.nix

# Edit host-specific configuration
vim hosts/newhostname/default.nix
```

### Building and Switching

```bash
# Build and switch system configuration
sudo nixos-rebuild switch --flake /etc/nixos#hostname

# Build and switch home-manager configuration
home-manager switch --flake /etc/nixos#username
```

### Managing Secrets

```bash
# Edit secrets
agenix -e secrets/newsecret.age

# Rekey all secrets after adding new keys
cd secrets && agenix --rekey
```

## Benefits of This Structure

1. **Modularity**: Each piece can be enabled/disabled independently
2. **Maintainability**: Easy to find and modify specific functionality
3. **Reusability**: Modules work across different hosts
4. **Scalability**: Adding new hosts/services is straightforward
5. **Clarity**: Purpose of each file is obvious from its location
6. **Type Safety**: Proper module structure allows for better error checking

## Migration Notes

When migrating from the old structure:

1. Services remain largely unchanged, just moved to appropriate subdirectories
2. User-level programs moved from `programs/` to `home/programs/`
3. Host configs import from new module locations
4. Secrets structure unchanged
5. All functionality preserved, just reorganized

## Contributing

When adding new functionality:

1. Place system-level configs in appropriate `modules/` subdirectory
2. Place user-level configs in appropriate `home/programs/` subdirectory
3. Update the relevant `default.nix` to include new modules
4. Follow existing patterns for consistency
5. Document any new options or special requirements
