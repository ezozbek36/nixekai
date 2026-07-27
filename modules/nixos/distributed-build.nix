{ ... }: {
  nix = {
    distributedBuilds = true;
    settings = {
      builders-use-substitutes = true;
    };
    buildMachines = [
      # {
      #   maxJobs = 100;
      #   speedFactor = 8;
      #   protocol = "ssh-ng";
      #   system = "x86_64-linux";
      #   hostName = "eu.nixbuild.net";
      #   supportedFeatures = ["benchmark" "big-parallel"];
      # }
      # {
      #   maxJobs = 16;
      #   speedFactor = 6;
      #   protocol = "ssh-ng";
      #   system = "x86_64-linux";
      #   hostName = "ns3.kolyma.uz";
      #   supportedFeatures = [
      #     "nixos-test"
      #     "benchmark"
      #     "big-parallel"
      #     "kvm"
      #   ];
      # }
      # {
      #   maxJobs = 24;
      #   speedFactor = 4;
      #   protocol = "ssh-ng";
      #   system = "x86_64-linux";
      #   hostName = "ns3.oss.uzinfocom.uz";
      #   supportedFeatures = [
      #     "nixos-test"
      #     "benchmark"
      #     "big-parallel"
      #     "kvm"
      #   ];
      # }
      # {
      #   maxJobs = 24;
      #   speedFactor = 2;
      #   sshUser = "builder";
      #   protocol = "ssh-ng";
      #   system = "x86_64-linux";
      #   hostName = "10.10.1.223";
      #   supportedFeatures = [
      #     "nixos-test"
      #     "benchmark"
      #     "big-parallel"
      #     "kvm"
      #     "gccarch-x86-64-v3"
      #   ];
      # }
    ];
  };
}
