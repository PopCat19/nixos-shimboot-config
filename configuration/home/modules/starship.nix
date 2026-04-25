# starship.nix
#
# Purpose: Configure Starship cross-shell prompt with Rose Pine styling
#
# This module:
# - Enables Starship prompt with custom format
# - Configures Git, language, and time modules
# - Applies Rose Pine color scheme styling

_: {
  programs.starship = {
    enable = true;
    settings = {
      format = "$time$directory$git_branch$git_status$line_break$character";

      character = {
        error_symbol = "[❯](bold love)";
        success_symbol = "[❯](bold foam)";
        vimcmd_symbol = "[❮](bold iris)";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        min_time = 2000;
        style = "bold gold";
      };

      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        read_only = " 󰌾";
        read_only_style = "love";
        style = "bold iris";
        truncate_to_repo = false;
        truncation_length = 3;
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        only_attached = true;
        style = "bold pine";
        symbol = " ";
      };

      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        conflicted = "=";
        deleted = "✘\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        modified = "!\${count}";
        renamed = "»\${count}";
        staged = "+\${count}";
        stashed = "≡\${count}";
        style = "bold rose";
        untracked = "?\${count}";
        up_to_date = "";
      };

      hostname = {
        format = "[$hostname]($style) in ";
        ssh_only = true;
        style = "bold foam";
      };

      memory_usage = {
        disabled = true;
        format = "[$symbol\${ram}(\${swap})]($style) ";
        style = "bold subtle";
        symbol = "🐏 ";
        threshold = 70;
      };

      nix_shell = {
        format = "[$symbol$state(\\($name\\))]($style) ";
        impure_msg = "[impure](bold love)";
        pure_msg = "[pure](bold foam)";
        style = "bold iris";
        symbol = " ";
      };

      nodejs = {
        format = "[$symbol($version)]($style) ";
        style = "bold pine";
        symbol = " ";
      };

      package = {
        format = "[$symbol$version]($style) ";
        style = "bold rose";
        symbol = "📦 ";
      };

      python = {
        format = "[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style) ";
        style = "bold gold";
        symbol = " ";
      };

      rust = {
        format = "[$symbol($version)]($style) ";
        style = "bold love";
        symbol = " ";
      };

      status = {
        disabled = true;
        format = "[$symbol$status]($style) ";
        style = "bold love";
        symbol = "✖ ";
      };

      time = {
        disabled = false;
        format = "[$time]($style) ";
        style = "bold muted";
        time_format = "%T";
        utc_time_offset = "local";
      };

      username = {
        format = "[$user]($style)@";
        show_always = false;
        style_root = "bold love";
        style_user = "bold text";
      };
    };
  };
}