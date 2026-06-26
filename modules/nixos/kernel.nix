{pkgs, ...}: let
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
in {
  boot.kernelPackages = pkgs.linuxKernel.packagesFor kernelPackage;
}
