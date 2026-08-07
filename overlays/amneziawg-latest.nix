final: prev: {
  linuxPackages = prev.linuxPackages // {
    amneziawg-tools = final.unstable.amneziawg-tools;
    amneziawg = final.unstable.linuxPackages.amneziawg;
  };
}