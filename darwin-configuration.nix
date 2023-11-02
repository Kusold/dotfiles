{ pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    ];

  environment.darwinConfig = "$HOME/.config/home-manager/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  homebrew.enable = true;
  homebrew.casks = [
    "1password"
  ];
  homebrew.masApps = {
    "Amphetamine" = 937984704;
  };

  home-manager.useUserPackages = true;
}
