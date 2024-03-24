{
  layer = "top";
  position = "top";
  modules-left = [
    "custom/menu"
    #"group/batteries"
    "clock"
    "custom/weather"
    "hyprland/workspaces"
  ];
  modules-center = [
    
  ];
  modules-right = [
    "tray"
    "group/scroll"
    "group/scripts"
    "group/hardware"
  ];
  "hyprland/workspaces" = {
    format = "{icon}";
    "on-click" = "activate";
    "all-outputs" = true;
    "persistent_workspaces" = {
      "1" = [];
      "2" = [];
      "3" = [];
      "4" = [];
      "5" = [];
      "6" = [];
      "7" = [];
      "8" = [];
      "9" = [];
      "10" = [];
    };
    "format-icons" = {
      active = "󰮯 ";
      default = "󰊠 ";
      empty = "󰧵 ";
    };
  };
  tray = {
    spacing = 8;
    "icon-size" = 12;
  };
  "group/scroll" = {
    orientation = "horizontal";
    modules = [
      "pulseaudio#mic"
      "pulseaudio"
      "backlight"
    ];
  };
  "group/batteries" = {
    orientation = "horizontal";
    modules = [
      "battery"
      "custom/batterysaver"
    ];
  };
  "group/scripts" = {
    orientation = "horizontal";
    modules = [
      "hyprland/submap"
      "custom/colorpicker"
      "idle_inhibitor"
      "custom/camera"
      "custom/notifications"
      "gamemode"
      "custom/updates"
      "custom/github"
      "bluetooth"
      "custom/recorder"
    ];
  };
  "group/hardware" = {
    orientation = "horizontal";
    modules = [
      "custom/vpn"
      "custom/hotspot"
      "network"
      "memory"
      "disk"
      "cpu"
      "custom/cputemp"
      "systemd-failed-units"
      "privacy"
    ];
  };
  "systemd-failed-units" = {
    "hide-on-ok" = true;
    format = "✗ {nr_failed}";
    "format-ok" = "";
    system = true;
    user = false;
  };
  privacy = {
    "icon-spacing" = 4;
    "icon-size" = 18;
    "transition-duration" = 250;
    modules = [
      {
        type = "screenshare";
        tooltip = true;
        "tooltip-icon-size" = 16;
      }
    ];
  };
  "pulseaudio#mic" = {
    format = "{format_source}";
    "format-source" = "{volume}% ";
    "format-source-muted" = "";
    "on-click" = "pactl set-source-mute 0 toggle";
    "on-scroll-down" = "pactl set-source-volume 0 -1%";
    "on-scroll-up" = "pactl set-source-volume 0 +1%";
  };
  pulseaudio = {
    format = "{volume}% {icon} ";
    "format-bluetooth" = "{volume}% {icon} ";
    "format-muted" = "󰝟";
    "format-icons" = {
      headphones = "";
      handsfree = "";
      headset = "";
      phone = "";
      portable = "";
      car = "";
      default = [
        ""
        ""
      ];
    };
    "on-click" = "~/.config/hypr/bin/volume mute";
    "on-click-middle" = "pavucontrol";
    "on-scroll-up" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
    "on-scroll-down" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
    "smooth-scrolling-threshold" = 1;
  };
  "custom/vpn" = {
    format = "{} ";
    exec = "~/.config/waybar/bin/vpn";
    "return-type" = "json";
    interval = 5;
  };
  "custom/hotspot" = {
    format = "{} ";
    exec = "~/.config/waybar/bin/hotspot";
    "return-type" = "json";
    "on-click" = "hash wihotspot && wihotspot";
    interval = 5;
  };
  network = {
    "format-wifi" = "  {bandwidthDownBits}";
    "format-ethernet" = "󰌗 {bandwidthDownBits}";
    "format-disconnected" = "󰌺";
    "format-linked" = "󰌹";
    "tooltip-format" = "{ipaddr}";
    "tooltip-format-wifi" = "{essid} ({signalStrength}%)  \n{ipaddr} | {frequency} MHz{icon} \n {bandwidthDownBits}  {bandwidthUpBits} ";
    "tooltip-format-ethernet" = "{ifname} 󰌗 \n{ipaddr} | {frequency} MHz{icon} \n󰌗 {bandwidthDownBits}  {bandwidthUpBits} ";
    "tooltip-format-disconnected" = "Not Connected to any type of Network";
    "on-click" = "pgrep -x rofi &>/dev/null && notify-send rofi || networkmanager_dmenu";
  };
  backlight = {
    device = "intel_backlight";
    format = "{percent}% {icon}";
    "format-icons" = [
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
    ];
    "on-scroll-down" = "brightnessctl s 5%-";
    "on-scroll-up" = "brightnessctl s +5%";
    tooltip = false;
    "smooth-scrolling-threshold" = 1;
  };
  battery = {
    states = {
      good = 95;
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon}";
    "format-charging" = "<b>{icon} </b>";
    "format-full" = "<span color='#00ff00'><b>{icon}</b></span> {capacity}%";
    "format-icons" = [
      "󰂃"
      "󰁺"
      "󰁻"
      "󰁼"
      "󰁾"
      "󰁿"
      "󰂀"
      "󰂁"
      "󰁹"
    ];
    "tooltip-format" = "{timeTo}\n{capacity} % | {power} W";
  };
  "custom/batterysaver" = {
    format = " {}";
    exec = "~/.config/waybar/bin/battsaver-toggle getdata";
    "on-click" = "~/.config/waybar/bin/battsaver-toggle menu";
    interval = "once";
    "return-type" = "json";
    signal = 5;
  };
  "custom/menu" = {
    format = "{}";
    exec = "echo '󰀻'";
    "on-click" = "rofi -show drun";
    interval = "once";
    signal = 5;
  };
  memory = {
    format = "{}% ";
  };
  disk = {
    interval = 600;
    format = "{percentage_used}% ";
    path = "/";
  };
  cpu = {
    format = "{usage}% ";
    "on-click" = "foot btop";
  };
  "custom/cputemp" = {
    format = "{}";
    exec = "~/.config/waybar/bin/cputemp_zen4";
    interval = 10;
    "return-type" = "json";
  };
  "custom/weather" = {
    format = " {}° ";
    tooltip = true;
    interval = 3600;
    exec = "wttrbar --location 'manaus'";
    "return-type" = "json";
  };
  "custom/colorpicker" = {
    format = "{}";
    "return-type" = "json";
    interval = "once";
    exec = "$HOME/.config/waybar/bin/colpicker/colorpicker -j";
    "on-click" = "sleep 1 && $HOME/.config/waybar/bin/colpicker/colorpicker";
    signal = 1;
  };
  "idle_inhibitor" = {
    format = "{icon}";
    "tooltip-format-activated" = "Idle Inhibitor is active";
    "tooltip-format-deactivated" = "Idle Inhibitor is not active";
    "format-icons" = {
      activated = "";
      deactivated = "";
    };
  };
  "hyprland/submap" = {
    format = "{}";
    "max-length" = 9;
    tooltip = false;
  };
  "custom/updates" = {
    format = "{}";
    interval = 3600;
    exec = "~/.config/waybar/bin/updatecheck";
    "return-type" = "json";
    "exec-if" = "exit 0";
    signal = 8;
  };
  gamemode = {
    "hide-not-running" = true;
    "icon-spacing" = 4;
    "icon-size" = 13;
    tooltip = true;
    "tooltip-format" = "Games running: {count}";
  };
#  "custom/github" = {
#    format = "{}";
#    "return-type" = "json";
#    interval = 3600;
#    signal = 9;
#    exec = "$HOME/.config/waybar/bin/github.sh";
#    "on-click" = "xdg-open https://github.com/notifications;pkill -RTMIN+9 waybar";
#  };
  "custom/camera" = {
    format = "{} ";
    interval = "once";
    exec = "[ -z \"$(lsmod | grep uvcvideo)\" ] && echo \"󰃿\nCamera Disabled\" || echo \"\"";
    "on-click" = "~/.config/hypr/bin/camera-toggle";
    signal = 3;
  };
  "custom/notifications" = {
    format = "<b>{}</b> ";
    exec = "~/.config/waybar/bin/not-dnd -j";
    "on-click" = "~/.config/waybar/bin/not-dnd";
    "return-type" = "json";
    interval = "once";
    signal = 2;
  };
  clock = {
    format = "{:%H:%M}";
    "format-alt" = "{:%A, %B %d, %Y (%R)}";
    "tooltip-format" = "<tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "month";
      "mode-mon-col" = 3;
      "weeks-pos" = "right";
      "on-scroll" = 1;
      "on-click-right" = "mode";
      format = {
        today = "<span color='#a6e3a1'><b><u>{}</u></b></span>";
      };
    };
  };
  "custom/recorder" = {
    format = "{}";
    interval = "once";
    exec = "echo ''";
    tooltip = "false";
    "exec-if" = "pgrep 'wl-screenrec'";
    "on-click" = "exec $HOME/.config/waybar/bin/recorder";
    signal = 4;
  };
  bluetooth = {
    "format-on" = "";
    "format-off" = "󰂲";
    "format-disabled" = "";
    "format-connected" = "<b>󰂰 {num_connections}</b>";
    "format-connected-battery" = "󰂱 {device_battery_percentage}%";
    "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
    "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
    "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
    "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
    "on-click" = "rofi-bluetooth -config ~/.config/rofi/menu.d/network.rasi -i";
  };
}
