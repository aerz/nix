{
  self,
  pkgs,
  ...
}: {
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.primaryUser = "aerz";
  system.defaults.loginwindow.GuestEnabled = false;
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.menuExtraClock = {
    Show24Hour = true;
  };

  system.defaults.dock = {
    autohide = true;
    autohide-time-modifier = 0.25;
    autohide-delay = 0.0;
    show-recents = false;
    persistent-apps = [
      "/Applications/Brave Browser.app"
      "/System/Applications/Mail.app"
      "/Applications/TickTick.app"
      "/Applications/kitty.app"
    ];
    wvous-tl-corner = 1;
    wvous-bl-corner = 1;
    wvous-tr-corner = 1;
    wvous-br-corner = 1;
  };

  # Aerospace
  system.defaults = {
    # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
    dock.expose-group-apps = true;
    # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-displays-have-separate-spaces
    spaces.spans-displays = true;
  };

  system.defaults.finder = {
    FXRemoveOldTrashItems = true;
    ShowPathbar = true;
    FXPreferredViewStyle = "Nlsv";
    FXEnableExtensionChangeWarning = false;
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    NewWindowTarget = "Home";
  };

  system.defaults.NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";

  system = {
    defaults.NSGlobalDomain = {
      KeyRepeat = 2; # 120, 90, 60, 30, 12, 6, 2
      InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15
      "com.apple.mouse.tapBehavior" = 1;
      ApplePressAndHoldEnabled = false;
      "com.apple.keyboard.fnState" = true;
    };
    defaults.hitoolbox.AppleFnUsageType = "Do Nothing";
    keyboard.enableKeyMapping = true;
  };

  system.defaults.CustomUserPreferences = {
    "digital.twisted.noTunes" = {
      "replacement" = "/Applications/Spotify.app";
      "hideIcon" = 1;
    };
    "com.apple.TextEdit" = {
      "RichText" = 0;
    };
    "com.aerz.Mid" = {
      "button" = 3;
      "speed" = 3;
      "toggle" = 0;
      "keys" = [];
    };
  };

  aerz.power-management.enable = true;

  networking.applicationFirewall = {
    enable = true;
    allowSigned = false;
    allowSignedApp = false;
    enableStealthMode = false;
    blockAllIncoming = false;
  };
}
