{
  pkgs,
  inputs,
  ...
}:
let
  kernelPackage = pkgs.cachyosKernels.linux-cachyos-latest.override {
    rt = true;
    bbr3 = true;
    kcfi = true;
    lto = "full";
    autofdo = true;
    hzTicks = "500";
    acpiCall = true;
    autoModules = false;
    cpusched = "rt-bore";
    performanceGovernor = true;
    processorOpt = "x86_64-v3";
  };
in
{
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.default
  ];

  boot.kernelPackages = pkgs.linuxKernel.packagesFor kernelPackage;
  boot.kernelPatches = [
    {
      name = "[PATCH] KVM: x86/tdx: Do not print error message on non-present feature";
      patch = pkgs.fetchpatch2 {
        url = "https://lore.kernel.org/kvm/20260702043204.81741-1-jirislaby@kernel.org/raw";
        hash = "sha256-K5bMOUbBf362FH7U7M0oeznM5fUlgf2myY8ipoYe5Tg=";
      };
    }
  ];
}
