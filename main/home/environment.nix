{
  userConfig,
  ...
}:
{
  home.sessionVariables = {
    EDITOR = userConfig.defaultApps.editor.command;
    VISUAL = userConfig.defaultApps.editor.command;
    BROWSER = userConfig.defaultApps.browser.command;
    TERMINAL = userConfig.defaultApps.terminal.command;
    FILE_MANAGER = userConfig.defaultApps.fileManager.command;
    # Required: compositing causes blank thumbnails on ChromeOS kernel
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";

    GDK_SCALE = "1";

    inherit (userConfig.env) NIXOS_CONFIG_DIR;
    NIXOS_CONFIG_PATH = "${userConfig.env.NIXOS_CONFIG_DIR}/shimboot_config";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "$HOME/bin"
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        b = userConfig.defaultApps.browser.desktop;
        fm = userConfig.defaultApps.fileManager.desktop;
        img = userConfig.defaultApps.imageViewer.desktop;
        vid = userConfig.defaultApps.videoPlayer.desktop;
        pdf = userConfig.defaultApps.pdfViewer.desktop;
      in
      {
        "text/html" = [ b ];
        "x-scheme-handler/http" = [ b ];
        "x-scheme-handler/https" = [ b ];
        "x-scheme-handler/about" = [ b ];
        "x-scheme-handler/unknown" = [ b ];
        "inode/directory" = [ fm ];
        "image/png" = [ img ];
        "image/jpeg" = [ img ];
        "image/gif" = [ img ];
        "image/webp" = [ img ];
        "video/mp4" = [ vid ];
        "video/mkv" = [ vid ];
        "video/webm" = [ vid ];
        "application/pdf" = [ pdf ];
      };
  };
}
