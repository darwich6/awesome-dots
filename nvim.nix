{ inputs, ... }:
{
  home-manager.users.ahmed = { config, pkgs, ... }: {
    nixpkgs.overlays = [ inputs.nixneovimplugins.overlays.default ];
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        ripgrep fd
        typescript typescript-language-server
        dockerfile-language-server yaml-language-server bash-language-server
        vscode-langservers-extracted
        nodePackages.prettier stylua black pyright
        nixd nixfmt-rfc-style lua-language-server gopls
      ];
      extraLuaConfig = ''
        -- Home Manager supplies plugin paths; settings are live checkout symlinks.
        local root = vim.fn.stdpath("config")
        dofile(root .. "/options.lua")
        dofile(root .. "/keymap.lua")
        require("platform_nix")
      '';
      plugins = with pkgs.vimPlugins; [
        plenary-nvim nui-nvim vim-suda telescope-nvim nvim-web-devicons vim-just
        nvim-autopairs nvim-surround neo-tree-nvim lualine-nvim
        indent-blankline-nvim blink-cmp go-nvim gitsigns-nvim dracula-nvim
        alpha-nvim conform-nvim nvim-lspconfig which-key-nvim
        # Nix provides matching parsers/queries; shared code uses native highlighting.
        nvim-treesitter.withAllGrammars
        {
          plugin = pkgs.vimExtraPlugins.possession-nvim-jedrzejboczar;
          type = "lua";
          config = ''dofile(vim.fn.stdpath("config") .. "/plugins/possession.lua")'';
        }
      ];
    };
  };
}
