# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, lib, pkgs, ... }:

{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # ============================================================================
  # SYSTEM SETTINGS
  # ============================================================================
  system.stateVersion = "25.11";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "1password-gui"
      "1password"
    ];

  # ============================================================================
  # BOOT & KERNEL
  # ============================================================================
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.enable = true;
  boot.loader.grub.configurationLimit = 5;
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # NETWORKING
  # ============================================================================
  networking.hostName = "homepc";
  networking.networkmanager.enable = true;

  # ============================================================================
  # INTERNATIONALIZATION
  # ============================================================================
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ============================================================================
  # HARDWARE
  # ============================================================================
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ============================================================================
  # SERVICES
  # ============================================================================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  virtualisation.docker.enable = true;

  # ============================================================================
  # FONTS
  # ============================================================================
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    font-awesome
    fira-code
    fira-code-symbols
    noto-fonts
  ];

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      custom = "$HOME/.oh-my-zsh/custom/";
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.waybar.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ahmed" ];
  };

  # ============================================================================
  # USERS
  # ============================================================================
  users.extraUsers.ahmed = { shell = pkgs.zsh; };
  users.users.ahmed = {
    isNormalUser = true;
    description = "ahmed";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # ============================================================================
  # HOME MANAGER
  # ============================================================================
  home-manager.users.ahmed = { pkgs, ... }: {
    home.stateVersion = "25.11";

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
    };

    programs.ghostty.enable = true;
    programs.firefox.enable = true;

    programs.zsh.initExtra = ''
      [[ ! -f ~/.aliases.zsh ]] || source ~/.aliases.zsh
    '';

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "nvim";
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
    };
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    neovim

    # Development Tools
    git
    delta
    direnv
    nodejs_24
    python315
    lua
    gcc
    rustup
    tree-sitter

    # Go Tools
    go
    gopls
    uv
    golines
    gotests
    richgo
    reftools
    ginkgo
    gotestsum
    gofumpt
    gomodifytags
    impl
    govulncheck
    mockgen

    # Shell & Terminal
    zsh
    oh-my-zsh
    eza
    fzf
    fd
    gnugrep
    ripgrep
    keychain

    # System Utilities
    unzip
    wget
    neofetch

    # Wayland/Hyprland Tools
    wofi
    hyprshot
    wpaperd
    hyprpicker
    swaynotificationcenter
    hyprpolkitagent

    # Applications
    spotify
    discord
    code-cursor

    # Themes & Icons
    adwaita-icon-theme
    meslo-lgs-nf
  ];

  # ============================================================================
  # UNUSED / COMMENTED OPTIONS
  # ============================================================================
  # networking.wireless.enable = true;
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
}
