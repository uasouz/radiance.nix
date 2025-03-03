{pkgs,inputs, ...}: let 
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
     export HYPRLAND_INSTANCE_SIGNATURE=$(find /tmp/hypr -print0 -name '*.log' | xargs -0 stat -c '%Y %n' - | sort -rn | head -n 1 | cut -d ' ' -f2 | awk -F '/' '{print $4}') 
     export WAYLAND_DISPLAY=$(grep -o "wayland-[0-9]" "$(find /tmp/hypr -print0 -name '*.log' | xargs -0 stat -c '%Y %n' - | sort -rn | head -n 1 | cut -d ' ' -f2)" | head -n 1)
  '';
  in {
  imports = [
    ./programs
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";

  home.packages = (with pkgs; [
    pkgs.hyprpaper
    # inputs.devenv.packages."${pkgs.system}".devenv
    pkgs.cachix
    pkgs.nerd-fonts.jetbrains-mono
    git
    jetbrains-toolbox
    slack
    curl
    rustup
    rustc
    lazygit
    jq
    appimage-run
    gcc
    nfs-utils
    networkmanagerapplet
    wttrbar
    lm_sensors
    ranger
    hyprshot
    kdePackages.xwaylandvideobridge
    lxqt.lxqt-policykit
    tmuxp
    obsidian
    insomnia
    btop
    godot_4
    blender
    elixir_1_18
    clojure
    clojure-lsp
    simplescreenrecorder
    obs-studio
    delve
    wl-clipboard
    cliphist
    kdePackages.filelight
    dive
    rye
    pkgs.python313Packages.python
    pkgs.python313Packages.pylint
    pkgs.python313Packages.pip
    pkgs.python313Packages.python-lsp-server
    zed-editor
    nordzy-cursor-theme
    xdg-desktop-portal-gtk
    amdvlk
    google-chrome
  ]);

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
      preload = ${/. + ./wallpapers/switch.jpg}
      wallpaper = ,${/. + ./wallpapers/switch.jpg}
      ipc = off
    '';

  home.file.".local/lib/import_env" = {
    source = ./programs/hypr/start.sh;
  };
  
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.systemd.enable= true;
  wayland.windowManager.hyprland.systemd.variables = ["-all"];
    
  wayland.windowManager.hyprland.extraConfig = ''
    
       exec-once=systemctl --user mask xdg-desktop-portal-gnome
       exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 
       exec-once = lxqt-policykit-agent

       exec-once = nm-applet --indicator
       exec-once = $HOME/.local/lib/import_env tmux
       exec-once = hyprpaper
       exec-once = waybar

       exec-once = wl-paste --type text --watch cliphist store

       exec-once = wl-paste --type image --watch cliphist store

       exec-once = hyprlock
  '';

  wayland.windowManager.hyprland.settings = {
     "$mod" = "SUPER";
     "$shiftMod" = "SHIFT SUPER";
    decoration = {
      rounding = 10;
    };
    input = {
        kb_layout = "us";
        kb_variant = "intl";
    };
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bind =
       [
         "$mod, L, exec, hyprlock"
         "$mod, Q, killactive"
         "$mod, T, exec, alacritty"
         "$mod, R, exec, fuzzel"
         "$mod, F, exec, dolphin"
         "$mod, P, exec, hyprshot -m window"
         "$mod, S, pin"
         "$shiftMod, F, togglefloating"
         "$shiftMod, P, exec, hyprshot -m region"
         "$mod, left, movefocus, l"
         "$mod, right, movefocus, r"
         "$mod, up, movefocus, u"
         "$mod, down, movefocus, d"
         "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
         "$shiftMod, H, movewindow, l"
         "$shiftMod, J, movewindow, d"
         "$shiftMod, K, movewindow, u"
         "$shiftMod, L, movewindow, r"
         "$shiftMod, left, resizeactive, -10 0"
         "$shiftMod, right, resizeactive, 10 0"
         "$shiftMod, up, resizeactive, 0 -10"
         "$shiftMod, down, resizeactive, 0 10"
       ]
       ++ (
         # workspaces
         # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
         builtins.concatLists (builtins.genList (
             x: let
               ws = let
                 c = (x + 1) / 10;
              in
                 builtins.toString (x + 1 - (c * 10));
             in [
               "$mod, ${ws}, workspace, ${toString (x + 1)}"
               "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
             ]
           )
           10)
       );
   };

programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };

      window = {
        opacity = 0.85;
      };

    terminal.shell = {
      program = "${pkgs.zsh}/bin/zsh";
      args = ["-lc" "tmux"];
    };

    colors = {
      primary = {
        background =  "0x171d23";
        foreground =  "0xFFFFFF";
      };

      cursor = {
        text = "0xFAFAFA";
        cursor = "0x008B94";
      };

      normal = {
        black =    "0x333f4a";
        red =      "0xd95468";
        green =    "0x8bd49c";
        blue =     "0x539afc";
        magenta =  "0xb62d65";
        cyan =     "0x70e1e8";
        white =    "0xb7c5d3";
      };

      bright = {
        black =    "0x41505e";
        red =      "0xd95468";
        green =    "0x8bd49c";
        yellow =   "0xebbf83";
        blue =     "0x5ec4ff";
        magenta =  "0xe27e8d";
        cyan =     "0x70e1e8";
        white =    "0xffffff";
      };
    };
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
        # split panes using | and -
        bind '\' split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %
        
        # reload config file (change file location to your the tmux.conf you want to use)
        bind r source-file ~/.tmux.conf
        
        # switch panes using Alt-arrow without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D
        
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi V send -X select-line
        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'       
        
        # Enable mouse mode (tmux 2.1 and above)
        set -g mouse on
        '';
  };

  programs.zsh = {
    shellAliases = {
      zd = "WAYLAND_DISPLAY='' zeditor .";
      n = "nvim .";
    };
    initExtra = ''
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
    '';
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" ];
    };
    zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
   ];
  };
  };

  programs.git = {
  enable = true;
  userName = "uasouz";
  userEmail = "vlopes45@gmail.com";
  extraConfig = {
      pull.rebase = "true";
      init = {
        defaultBranch = "main";
      };
      url = {
        "https://github.com/" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };

}
