{pkgs, ...}: {
  programs.spicetify = {
    enable = true;
    wayland = false;
    windowManagerPatch = true;
    enabledCustomApps = with pkgs.spicetify.apps; [lyricsPlus];
    enabledExtensions = with pkgs.spicetify.extensions; [
      adblockify
      hidePodcasts
      aiBandBlocker
      spotifyGenres
    ];
  };
}
