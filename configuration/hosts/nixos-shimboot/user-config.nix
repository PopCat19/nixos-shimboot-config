# user-config.nix
#
# Purpose: Host-specific user configuration for nixos-shimboot
rec {
  system = "x86_64-linux";
  hostname = "nixos-shimboot";
  username = "nixos-user";
  profile = "shimboot";
  board = "dedede";

  host = {
    inherit hostname system board;
  };

  timezone = "America/New_York";
  locale = "en_US.UTF-8";

  user = {
    inherit username;
    initialPassword = "nixos-shimboot";
    shell = "fish";
    shellPackage = "fish";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "i2c"
      "input"
      "libvirtd"
    ];
  };

  defaultApps = {
    browser = {
      desktop = "zen-twilight.desktop";
      package = "zen-browser";
      command = "zen-twilight";
    };

    terminal = {
      desktop = "kitty.desktop";
      package = "kitty";
      command = "kitty";
    };

    editor = {
      desktop = "micro.desktop";
      package = "micro";
      command = "micro";
    };

    fileManager = {
      desktop = "org.kde.dolphin.desktop";
      package = "kdePackages.dolphin";
      command = "dolphin";
    };

    imageViewer = {
      desktop = "org.kde.gwenview.desktop";
      package = "kdePackages.gwenview";
    };

    videoPlayer = {
      desktop = "mpv.desktop";
      package = "mpv";
    };

    archiveManager = {
      desktop = "org.kde.ark.desktop";
      package = "kdePackages.ark";
    };

    pdfViewer = {
      desktop = "zen-twilight.desktop";
      package = "zen-browser";
    };

    launcher = {
      desktop = "fuzzel.desktop";
      package = "fuzzel";
      command = "fuzzel";
    };

    clipboard = {
      command = "bash -lc \"cliphist list | fuzzel --dmenu --with-nth 2 | cliphist decode | wl-copy && sleep 0.05 && wtype -M ctrl -k v\"";
    };
  };

  directories =
    let
      home = "/home/${username}";
    in
    {
      inherit home;
      desktop = "${home}/Desktop";
      documents = "${home}/Documents";
      downloads = "${home}/Downloads";
      music = "${home}/Music";
      pictures = "${home}/Pictures";
      videos = "${home}/Videos";
    };

  fonts = {
    monospace = {
      packageName = "fira-code";
      name = "FiraCode Nerd Font";
      size = 10;
    };

    sansSerif = {
      packageName = "google-fonts";
      name = "Rounded Mplus 1c Medium";
    };

    serif = {
      packageName = "noto-fonts";
      name = "Noto Serif";
    };

    emoji = {
      packageName = "noto-fonts-color-emoji";
      name = "Noto Color Emoji";
    };
  };

  theme = {
    hue = 30;
    variant = "dark";
  };

  env = {
    NIXOS_CONFIG_DIR = "${directories.home}/nixos-shimboot-config";
  };
}
