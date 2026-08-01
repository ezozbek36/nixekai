{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "intel-lpmd";
  version = "0.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-lpmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eZBgWpR2tdSDeqYV4Y2h2j5UeJebQg2tXlXcUywwZEA=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Intel Low Power Mode Daemon";
    homepage = "https://github.com/intel/intel-lpmd";
    changelog = "https://github.com/intel/intel-lpmd/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "intel-lpmd";
    platforms = lib.platforms.all;
  };
})
