{ ... }: {
  imports = [ ./root.nix ];
  config = { machineLabel = builtins.getEnv "HOSTNAME"; };
}
