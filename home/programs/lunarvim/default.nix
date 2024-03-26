{config,pkgs,...}:{

  home.file.".config/lvim/config.lua" = {
    source = ./config.lua;
    force = true;
  };
  home.packages = (with pkgs; [
    lunarvim
  ]);


}
