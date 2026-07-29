{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    pciutils
    usbutils
    btop-cuda
    lm_sensors
    libva-utils
    vulkan-tools
    intel-gpu-tools
  ];
}
