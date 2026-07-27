{
  inputs,
  modulesPath,
  ...
}:
{
  imports =
    [ ]
    ++ [ "${modulesPath}/installer/scan/not-detected.nix" ]
    ++ (with inputs.nixos-hardware.nixosModules; [ common-pc ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-pc-ssd ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-cpu-intel ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-gpu-intel ])
    ++ [ ];

  hardware.facter.reportPath = ./facter.json;
}
