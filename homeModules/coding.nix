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
  home.packages = with llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    fx
    t3code-desktop
    t3code
    (chatgpt.override {
      commandLineArgs = "--enable-features=UseOzonePlatform";
    })
    codex
    opencode2
    opencode
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
}
