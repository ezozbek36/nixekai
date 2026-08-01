{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chwd";
  version = "1.12.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "chwd";
    tag = finalAttrs.version;
    hash = "sha256-ChUP1Kk77vVhAmpWZScCk7QoHwXf7xvGaWA8OoKpSNc=";
  };

  cargoHash = "sha256-qPQomRRBeNe2cmMj60iDlz9WT+aUPsY9FImITVT/8GY=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hardware Detection and Configuration for CachyOS";
    homepage = "https://github.com/CachyOS/chwd";
    changelog = "https://github.com/CachyOS/chwd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "chwd";
  };
})
