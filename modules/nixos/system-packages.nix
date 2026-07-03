{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    btop
    intel-gpu-tools
    libva-utils
    vulkan-tools
    pciutils
    usbutils
    lm_sensors
  ];
}
