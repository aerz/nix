_final: prev: {
  mas = prev.stdenvNoCC.mkDerivation rec {
    pname = "mas";
    version = "6.0.1";

    src =
      let
        sources = {
          aarch64-darwin = {
            arch = "arm64";
            hash = "sha256-BZ9UE8H28kjqiMNdLDUUyC9madR4rBV1mLUGyj6ol3Y=";
          };
          x86_64-darwin = {
            arch = "x86_64";
            hash = "sha256-7+iDBr4GG5bdTuAlAmMQkEkIzVgLo2+DEdravClaLtQ=";
          };
        }.${prev.stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system: ${prev.stdenvNoCC.hostPlatform.system}");
      in
      prev.fetchurl {
        url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}-${sources.arch}.pkg";
        inherit (sources) hash;
      };

    nativeBuildInputs = with prev; [
      installShellFiles
      libarchive
      p7zip
    ];

    unpackPhase = ''
      runHook preUnpack
      7z x "$src"
      bsdtar -xf Payload~
      runHook postUnpack
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      installBin usr/local/opt/mas/bin/mas
      installManPage usr/local/opt/mas/share/man/man1/mas.1
      installShellCompletion --bash usr/local/opt/mas/etc/bash_completion.d/mas
      installShellCompletion --fish usr/local/opt/mas/share/fish/vendor_completions.d/mas.fish
      runHook postInstall
    '';

    meta = {
      description = "Mac App Store command line interface";
      homepage = "https://github.com/mas-cli/mas";
      license = prev.lib.licenses.mit;
      mainProgram = "mas";
      platforms = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  };
}
