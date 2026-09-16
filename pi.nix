{ inputs, ... }:
{
  home-manager.users.ahmed = { pkgs, ... }: {
    home.packages = [
      inputs.nixpkgs-pi.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pi-coding-agent
    ];
  };
}
