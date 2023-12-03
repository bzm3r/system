{ ... }: {
  programs.zsh = {
    enable = true;
    histSize = 1000;
    histFile = "~/.histfile";
    enableCompletion = true;
    enableGlobalCompInit = true;
    syntaxHighlighting = {
      highlighters = [ "main" ];
    };
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
      async = true;
      highlightStyle = "fg=3";
    };
    enableLsColors = true;
    # loginShellInit = ''
    # if [ -z $WAYLAND ] && [ $XDG_VTNR -eq 1 ]; then
    #   exec sway
    # fi
    # '';
  };

  # environment.systemPackages = [
  # ];
}