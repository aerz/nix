{pkgs, ...}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [prettybat];
    config = {
      theme = "base16";
    };
  };
}
