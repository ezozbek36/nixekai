{ ... }: {
  hardware.bluetooth = {
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };
}
