{}:{
  programs.lunarvim = {
    enable = true;
  };

  home.file.".config/lvim/config.lua".source = ./config.lua;
}
