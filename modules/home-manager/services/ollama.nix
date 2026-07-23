{ ... }: {
  services.ollama = {
    enable = false;
    acceleration = "cuda";
    #serviceConfig = {
    #  Environment = [
    #    "CUDA_VISIBLE_DEVICES=0"
    #    "NVIDIA_VISIBLE_DEVICES=all"
    #    # Optional: Force the render offload flags if CUDA alone isn't waking it
    #    "__NV_PRIME_RENDER_OFFLOAD=1"
    #    "__NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0"
    #    "__GLX_VENDOR_LIBRARY_NAME=nvidia"
    #  ];
    #};
  };
}
