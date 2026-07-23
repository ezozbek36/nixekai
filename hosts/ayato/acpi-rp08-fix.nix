{
  lib,
  cpio,
  stdenv,
  acpica-tools,
  ...
}:
stdenv.mkDerivation {
  name = "acpi-rp08-fix.cpio";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./acpi-rp08-fix.dsl ];
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  nativeBuildInputs = [
    cpio
    acpica-tools
  ];

  installPhase = ''
    mkdir -p kernel/firmware/acpi

    iasl -p kernel/firmware/acpi/rp08-fix $src/acpi-rp08-fix.dsl

    find kernel | cpio -H newc --create > $out
  '';
}
