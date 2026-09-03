{
  lib,
  curl,
  glib,
  gtk4,
  zlib,
  cargo,
  cairo,
  meson,
  rustc,
  pango,
  ninja,
  stdenv,
  openssl,
  alsa-lib,
  libadwaita,
  pkg-config,
  gdk-pixbuf,
  rustPlatform,
  libpulseaudio,
  wrapGAppsHook4,
  fetchFromGitHub,
  nix-update-script,
  blueprint-compiler,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riff";
  version = "26.7.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Diegovsky";
    repo = "riff";
    tag = "v8";
    hash = "sha256-LblZ6/Oo/L86a+LzBR8r3rTaySPbRgyM+F+ClkMyXqY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-2TNWubnoyFWkM48C2/mf02y6xvbwcAZjtCJRelsbY9w=";
  };

  nativeBuildInputs = [
    curl
    cargo
    meson
    ninja
    rustc
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    zlib
    gtk4
    glib
    curl
    pango
    cairo
    openssl
    gdk-pixbuf
    libadwaita
    libpulseaudio
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native Spotify client for the GNOME desktop.";
    homepage = "https://github.com/Diegovsky/riff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "riff";
    platforms = lib.platforms.linux;
  };
})
