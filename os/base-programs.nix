{ pkgs, ... }:

{
  programs = {
    # a better traceroute
    mtr.enable = true;

    # enable git globally, config is at home level
    git = {
      enable = true;
      lfs.enable = true;
    };

    zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
        strategy = [ "completion" "history" ];
        async = true;
      };
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };
  };

  documentation.man.man-db.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix # no vim or emacs allowed
    rustup
    mold
    sccache

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    bat # nicer cat
    lsd # nicer ls
    fzf # A command-line fuzzy finder
    file
    which
    tree
    zstd
    gnupg
    broot
    dust
    halp
    mtr # A network diagnostic tool
    fd
    lsd
    most

    man-db
    man-pages

    btrfs-progs
    f2fs-tools
    dosfstools
    e2fsprogs
    wget
    curl
    seatd

    distrobox

    zsh-powerlevel10k
  ];
}