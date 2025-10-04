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
    persistent-apps = [
      "${pkgs.brave}/Applications/Brave Browser.app"
      "/System/Applications/Mail.app"
      "/Applications/TickTick.app"
      "${pkgs.wezterm}/Applications/WezTerm.app"
    ];
    wvous-tl-corner = 1;
    wvous-bl-corner = 1;
    wvous-tr-corner = 1;
    wvous-br-corner = 1;
  };

  system.defaults.finder = {
      ShowPathbar = true;
      FXPreferredViewStyle = "clmw";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
  };

  system = {
    defaults.NSGlobalDomain = {
      KeyRepeat = 2; # 120, 90, 60, 30, 12, 6, 2
      InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15
      "com.apple.mouse.tapBehavior" = 1;
      ApplePressAndHoldEnabled = false;
    };

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;
  };

  system.defaults.CustomUserPreferences = {
    "digital.twisted.noTunes" = {
      "replacement" = "/Applications/Spotify.app";
      "hideIcon" = 1;
    };
  };
}