{...}: {
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  services.swapspace = {
    enable = true;
  };
}
