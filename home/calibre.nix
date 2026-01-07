{
  config,
  pkgs,
  lib,
  ...
}:

let
  calibreDataDir = "/Volumes/U500/AppData/Calibre";
in
{
  # https://manual.calibre-ebook.com/customize.html
  home.file."Library/Preferences/calibre/macos-env.txt" = {
    text = ''
      CALIBRE_CONFIG_DIRECTORY=${calibreDataDir}/config
      CALIBRE_CACHE_DIRECTORY=${calibreDataDir}/cache
      CALIBRE_TEMP_DIR=${calibreDataDir}/temp
      CALIBRE_OVERRIDE_DATABASE_PATH=${calibreDataDir}/metadata.db
    '';
    recursive = true;
  };

  home.activation.mkdirCalibreData = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "/Volumes/U500" ]; then
      run mkdir -p "${calibreDataDir}/config"
      run mkdir -p "${calibreDataDir}/cache"
      run mkdir -p "${calibreDataDir}/temp"
      run mkdir -p "${calibreDataDir}/Books"
    else
      verboseEcho "WARN: /Volumes/U500 is not mounted"
    fi
  '';
}
