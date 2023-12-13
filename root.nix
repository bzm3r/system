{ lib, pkgs, config, ... }: {
  imports = [ ./nixos/hw-config.nix ./nixos/configuration.nix ];

  options = {
    homeBase = lib.options.mkOption {
      type = lib.types.str;
      default = lib.strings.normalizePath "/home";
      description = lib.mdDoc
        "Default base directory used for [normal user homes](https://github.com/NixOS/nixpkgs/blob/90c3374749364dc58f7077e4cfb53caa0bd29350/nixos/modules/config/users-groups.nix#L364).";
    };
    sources = lib.options.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      example = "{ nixpkgs = { ... }; rust-shell = { ... }; }";
      description = lib.mdDoc "Derivation of a rust-shell package";
    };
    singleUser = lib.options.mkOption {
      type = lib.types.str;
      example = "alfred";
      description =
        lib.mdDoc "Username of the primary user for this machine, as a string.";
    };
    userHome = lib.options.mkOption {
      type = lib.types.str;
      example = "/home/alfred";
      default = "/home/${config.singleUser}";
      description =
        lib.mdDoc "Home directory of the primary user for this machine.";
    };
    machineLabel = lib.options.mkOption {
      type = lib.types.enum [ "d" "l" ];
      example = "d";
      description = lib.mdDoc "Host machine selection.";
    };
    sysEntryDir = lib.options.mkOption {
      type = lib.types.nullOr lib.types.str;
      example = "/home/alfred/system";
      description = lib.mdDoc "Location of the system's `root.nix`.";
    };
    sysConfigDir = lib.options.mkOption {
      type = lib.types.nullOr lib.types.str;
      example = "/home/alfred/system/system";
      description = lib.mkDoc "Location of the system's `entry-point.nix`.";
    };
  };

  config = {
    singleUser = lib.mkForce "bzm3r";
    sources = lib.mkForce (import ./npins);
    sysEntryDir =
      lib.mkForce (lib.strings.normalizePath (builtins.getEnv "SYS_ENTRY_DIR"));
    sysConfigDir =
      lib.mkForce (lib.strings.normalizePath (builtins.getEnv "SYS_CONFIG_DIR"));

    environment.systemPackages = with pkgs;
      [
        # We're using niv to manage the systems Nixpkgs version, install it globally for ease
        npins
      ];

    # Use the Nixpkgs config and overlays from the local files for this NixOS build
    nixpkgs = {
      config = import ./nixpkgs/config.nix;
      overlays = import ./nixpkgs/overlays.nix;
    };

    # Makes commands default to the same Nixpkgs, config, overlays and NixOS configuration
    nix.nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixos-config=${toString ./root.nix}"
      "nixpkgs-overlays=${toString ./nixpkgs/overlays.nix}"
    ];

    environment.variables = {
      NIXPKGS_CONFIG = lib.mkForce (toString ./nixpkgs/config.nix);
      NIX_PATH = lib.mkForce (builtins.getEnv "NIX_PATH");
      NIX_SYS_CONFIG = lib.mkForce (toString ../.);
    };

    # Remove the stateful nix-channel command
    environment.extraSetup = ''
      rm --force $out/bin/nix-channel
    '';

    # This option is broken when set false, prevent people from setting it to false
    # And we implement the important bit above ourselves
    nix.channel.enable = true;
  };
}
