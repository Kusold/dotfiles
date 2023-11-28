{ config, lib, pkgs, pkgs-unstable, gui, darwin, inputs, ... }@args: {
    imports = [] 
      ++ lib.optionals(darwin) [
        ( import ./darwin.nix (args) )
      ];

    home.stateVersion = "23.05";
    home.packages = [
      pkgs.awscli2
      pkgs.aws-sam-cli
      pkgs.bat
      pkgs.gh
      pkgs.htop
      pkgs.jq
      pkgs.k9s
      pkgs.ponysay
      pkgs.restic
      pkgs.ripgrep
      pkgs.ssh-copy-id
      pkgs.tree
      pkgs.unar
      
      pkgs.wget
      pkgs-unstable.yt-dlp
      pkgs.shellcheck

      # Added while trying to get neovim working well
      pkgs.gnumake
      pkgs.gcc
      pkgs.nodejs_20
      pkgs.unzip
      pkgs.go
    ] ++ lib.optionals (gui) [
        pkgs-unstable.jetbrains.idea-ultimate
        pkgs-unstable.vscode
    ];
    programs.home-manager.enable = true;
    programs.git = {
      enable = true;
      includes = [{ path = "~/.config/home-manager/config/git/config"; }];
    };
    
    programs.kitty = {
      enable = if gui then true else false; # Yes, this could just be gui, but I'm still playing with how I want to structure this.
      darwinLaunchOptions = [
        "--single-instance"
      ];
      font.name = "FiraCode Nerd Font";
      font.size = 11;
      theme = "Dark One Nuanced";
      settings = {
        update_check_interval = 0;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        macos_quit_when_last_window_closed = true;
        confirm_os_window_close = 0;
      };
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    home.file."./.config/nvim/" = {
    #  source = ../config/nvim;
     source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/config/nvim";
     recursive = false;
    };
    #home.file."./.config/nvim/" = {
    # source = ../config/nvim;
    # recursive = true;
    #};
    #home.file."./.config/nvim/lazy-lock.json" = {
    # source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/config/nvim/lazy-lock.rw.json";
    # recursive = false;
    #};
    programs.zsh = {
      enable = true;
      # dotDir doesn't allow me to manage that directory myself
      #dotDir = ".config/zsh";
      initExtraFirst = ''
        export ZDOTDIR=~/.config/zsh
        . $ZDOTDIR/.zshenv
        . $ZDOTDIR/.zlogin
        . $ZDOTDIR/.zprofile
      '';
      initExtraBeforeCompInit = ''
        . $ZDOTDIR/.zshrc
      '';
    };
    home.file."./.config/zsh/" = {
     source = ../config/zsh;
     recursive = true;
    };

    home.file."./bin/" = {
     source = ../bin;
     recursive = true;
    };
}
