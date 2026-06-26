{pkgs, ...}: {
  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;

    initrd.systemd.enable = true;

    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [pkgs.mac-style-plymouth];
    };

    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "intel_pstate=active"
    ];

    kernel.sysctl = {
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.page-cluster" = 0;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
