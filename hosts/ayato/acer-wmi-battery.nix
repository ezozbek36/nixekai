{
  lib,
  kernel,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "acer-wmi-battery";
  version = "0.2.0";

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "frederik-h";
    repo = "acer-wmi-battery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CyKRpE3cnhEIFHc4Hal2PQUW7cd5k8+55S4QdSqGvNI=";
  };

  makeFlags = kernelModuleMakeFlags;

  postPatch = ''
    substituteInPlace Makefile \
        --replace-fail '/lib/modules/$(shell uname -r)/build' "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';

  installPhase = ''
    runHook preInstall

    find . -name '*.ko' -exec xz -f {} \;
    install -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86 *.ko.xz

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A linux kernel driver for the Acer WMI battery health control interface";
    homepage = "https://github.com/frederik-h/acer-wmi-battery";
    changelog = "https://github.com/frederik-h/acer-wmi-battery/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [peterhoeg];
    platforms = lib.platforms.linux;
  };
})
