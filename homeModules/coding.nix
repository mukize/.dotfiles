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
