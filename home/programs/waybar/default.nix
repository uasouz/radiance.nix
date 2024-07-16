{pkgs,...}:
let settings = (import ./bars/top.nix);
in
{


  home.packages = (with pkgs; [
    pulseaudio
    mako
    libnotify
  ]);


  services.mako = {
    enable = true;
    defaultTimeout = 4000;
    borderRadius = 15;
    borderColor = "#88cd00";
    extraConfig = ''
      [urgency=low]
      border-color=#cccccc
      
      [urgency=normal]
      border-color=#d08770
      
      [urgency=high]
      border-color=#bf616a
      default-timeout=0
    '';
  };

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
