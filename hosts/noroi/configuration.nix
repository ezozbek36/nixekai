{ezModules, ...}: {
  system.stateVersion = "26.05";

  imports =
    []
    ++ [./sshd.nix]
    ++ [./users.nix]
    ++ [./disko.nix]
    ++ [ezModules.nix]
    ++ [./secrets.nix]
    ++ [./hardware.nix]
    ++ [./wireguard.nix]
    ++ [ezModules.kmscon]
    ++ [./networking.nix]
    ++ [./boot-loader.nix]
    ++ [ezModules.cachyos-kernel]
    ++ [];

  nix = {
    implementation = "lix";
    patchLixPipeOperator = true;
    settings = {
      trusted-users = ["builder"];
      system-features = ["gccarch-x86-64-v3"];
    };
  };
}
