{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.aerz.power-management;
in {
  options.aerz.power-management = {
    enable = mkEnableOption "power management settings";

    disablePowerNap = mkOption {
      type = types.bool;
      default = true;
      description = "Disable Power Nap (reduces DarkWake frequency)";
    };

    disableTcpKeepAlive = mkOption {
      type = types.bool;
      default = true;
      description = "Disable TCP Keep Alive during sleep";
    };

    disableWakeOnLan = mkOption {
      type = types.bool;
      default = true;
      description = "Disable Wake-on-LAN";
    };
  };

  config = mkIf cfg.enable {
    networking.wakeOnLan.enable = mkIf cfg.disableWakeOnLan false;

    # system.activationScripts usability is unclear
    # https://github.com/nix-darwin/nix-darwin/issues/663
    system.activationScripts.extraActivation.text = lib.mkAfter ''
      echo 'configuring power-management...'
      ${optionalString cfg.disablePowerNap ''
        sudo pmset -a powernap 0
      ''}
      ${optionalString cfg.disableTcpKeepAlive ''
        sudo pmset -a tcpkeepalive 0
      ''}
    '';
  };
}
