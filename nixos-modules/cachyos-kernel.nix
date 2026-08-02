{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.default
  ];

  boot.kernelPackages =
    pkgs.linuxPackagesFor
    <| pkgs.cachyosKernels.linux-cachyos-latest.override
    <| {
      lto = "thin";
      processorOpt = "x86_64-v3";

      bbr3 = true;
      ccHarder = true;
      hzTicks = "500";
      tickrate = "full";
      cpusched = "bore";
      hugepage = "madvise";
      preemptType = "full";
    };

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
