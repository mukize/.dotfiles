{ llm-agents, pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.shellAliases = {
    "nv" = "nvim";
    "nb" = "nix build";
    "p" = "pnpm";
    "px" = "pnpx";
    "py" = "python3";
  };
  home.packages =
    let
      agents = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    with pkgs;
    [
      agents.fx
      agents.t3code-desktop
      agents.t3code
      (agents.chatgpt.override {
        commandLineArgs = "--enable-features=UseOzonePlatform";
      })
      agents.codex
      agents.opencode2
      agents.opencode
      herdr
      tree-sitter
      neovim
      tinymist
      typst
      gcc
      cargo
      nodejs_24
      pnpm
      python3
      uv
      lua-language-server
      nil
    ];

  programs = {
    gh.enable = true;
    zellij = {
      enable = true;
      enableZshIntegration = true;
      attachExistingSession = true;
      plugins = with pkgs.zellijPlugins; [
        zjstatus
        vim-zellij-navigator
      ];
      settings = {
        simplified_ui = true;
        default_mode = "locked";
        pane_frames = false;
      };
      extraConfig = builtins.readFile ../configs/extraConfig.kdl;
    };
    java = {
      enable = true;
      package = pkgs.jdk25;
    };
    tmux = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_flavor 'macchiato'
        run ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

        set -g status-left ""
        set -g status-right '#[fg=#{@thm_crust},bg=#{@thm_teal}] session: #S '
        set -g status-right-length 100
        set -g status-style padding=0
      '';
    };
  };
}
