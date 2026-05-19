{...}: {
  nix = {
    distributedBuilds = true;
    settings = {
      builders-use-substitutes = true;
    };
    buildMachines = [
      {
        maxJobs = 100;
        protocol = "ssh-ng";
        system = "x86_64-linux";
        hostName = "eu.nixbuild.net";
        supportedFeatures = ["benchmark" "big-parallel"];
      }
      {
        maxJobs = 8;
        speedFactor = 1;
        protocol = "ssh";
        system = "x86_64-linux";
        hostName = "ns3.oss.uzinfocom.uz";
        supportedFeatures = [
          "big-parallel"
          "kvm"
          "nixos-test"
          "benchmark"
        ];
      }
    ];
  };
}
