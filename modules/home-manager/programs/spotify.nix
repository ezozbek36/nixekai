{ pkgs, ... }: {
  programs.spicetify = {
    enable = true;
    wayland = true;
    windowManagerPatch = true;
    enabledCustomApps = with pkgs.spicetify.apps; [ lyricsPlus ];
    enabledExtensions = with pkgs.spicetify.extensions; [
      adblockify
      hidePodcasts
      aiBandBlocker
      spotifyGenres
    ];
  };
}
