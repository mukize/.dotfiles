{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,

  alsa-lib,
  gtk3,
  webkitgtk_4_1,
  libsoup_3,
  glib-networking,
  curlWithGnuTls,
  makeWrapper,
  nix-update-script,
  symlinkJoin,
  freetype,
  libgcc,
  libx11,
  fontconfig,
  gst_all_1,
}:

let
  # Resolves being unable to wrapGApp audio plugins
  webkitgtkWrapped = symlinkJoin {
    name = webkitgtk_4_1.name;
    paths = [ webkitgtk_4_1 ];
    nativeBuildInputs = [ makeWrapper ];
    postBuild = ''
      webkitLib="$out/lib/libwebkit2gtk-4.1.so.0"
      realWebkitLib="$(readlink -f "$webkitLib")"

      rm "$webkitLib"
      cp "$realWebkitLib" "$webkitLib"

      sed -i "s|${webkitgtk_4_1}|$out|g" "$webkitLib"

       wrapProgram \
         "$out/libexec/webkit2gtk-4.1/WebKitNetworkProcess" \
         --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${
          lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
          ]
        }"
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tone3000-plugin";
  version = "0.0.9";

  src = fetchurl {
    url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}/TONE3000-v${finalAttrs.version}-linux-x64.tar.gz";
    hash = "sha256-PiP7Y5ZfMQg0CQwcrgNX6gsnnPwU1pgOO+sLe1pUtUY=";
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
      webkitgtkWrapped
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
