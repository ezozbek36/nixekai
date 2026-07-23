{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    btop
    pciutils
    usbutils
    lm_sensors
    libva-utils
    vulkan-tools
    intel-gpu-tools
  ];
}
