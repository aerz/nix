{ self, pkgs, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.primaryUser = "aerz";
  system.defaults.loginwindow.GuestEnabled = false;
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.dock = {
    autohide = true;
    show-recents = false;
    expose-group-apps = true;
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

  system.defaults.finder = {
    ShowPathbar = true;
    FXPreferredViewStyle = "Nlsv";
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    NewWindowTarget = "Home";
  };

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
  };
}
