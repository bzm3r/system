{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./default-dirs.nix
    ./usr.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  i18n.defaultLocale = "en_US.UTF-8";

  # a bigger, default tty font
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-122n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  security = {
    sudo.extraConfig =
    '' Defaults lecture = never '';
    polkit.enable = true;
  };

  services = {
    # hardware scanner + firmware recommender
    fwupd.enable = true;
    udisks2.enable = true;
 };

  # should set up one-time auto-detect (perhaps on startup/login)
  time.timeZone = "America/Vancouver";

  system.stateVersion = "23.11"; # Apparently, no need to change, in order to make it robust to syntax issues...
}
