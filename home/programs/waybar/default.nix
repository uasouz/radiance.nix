{pkgs,...}:
let settings = (import ./bars/top.nix);
in
{


  home.packages = (with pkgs; [
    pulseaudio
    mako
    libnotify
  ]);


  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [settings];
  };


  home.file.".config/waybar/bin/" = {
      source = ./bin;
      recursive = true;
  };

  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/colors.css".source = ./colors.css;

}
