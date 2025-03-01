{config,pkgs,...}:{

  home.file.".config/nvim/init.lua" = {
    source = ./config.lua;
    force = true;
  };
  home.file.".config/nvim/ollama_provider.lua" = {
    source = ./ollama_provider.lua;
    force = true;
  };
 
  home.packages = (with pkgs; [
    neovim
    code-minimap
    nodejs_22
    ripgrep
    gnumake
  ]);


}
