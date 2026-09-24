{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  nix-update-script,

  alsa-lib,
  gtk3,
  libsoup_3,
  curlWithGnuTls,
  freetype,
  libgcc,
  libx11,
  fontconfig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tone3000-plugin";
  version = "0.0.10";

  src = fetchurl {
    url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}-alpha/TONE3000-v${finalAttrs.version}-linux-x64.tar.gz";
    hash = "sha256-lWjdbsFA5bBbuKpZO3ewPi+yu5Q9zWYiP1Md3cYyV0U=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    fontconfig.lib
    libx11
    libgcc.lib
    freetype
  ];

  # patchelf doesn't add runtimeDependencies to clap rpath
  appendRunpaths = [
    (lib.makeLibraryPath [
      curlWithGnuTls.out
      libsoup_3
      gtk3
    ])
  ];

  postPatch = ''
    patchShebangs ./install.sh
  '';

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    export VST3_DIR="$out/lib/vst3"
    export LV2_DIR="$out/lib/lv2"
    export CLAP_DIR="$out/lib/clap"
    export BIN_DIR="$out/bin"
    export DATA_DIR="$out/share"
    export CONFIG_DIR="$out/share/tone3000"

    ./install.sh

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "NAM and IR loader plugin for TONE3000";
    homepage = "https://github.com/tone-3000/tone3000-plugin";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "TONE3000";
  };
})
