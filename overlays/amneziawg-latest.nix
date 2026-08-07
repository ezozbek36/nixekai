final: prev: {
  amneziawg-tools = final.unstable.amneziawg-tools;
  linuxPackages = prev.linuxPackages // {
    amneziawg = final.unstable.linuxPackages.amneziawg;
  };
}
