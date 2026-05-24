{ theme ? null, colors ? null, extensions ? [] }:

final: prev: {
  spotify = prev.spotify.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ final.python3 ];

    postFixup = (old.postFixup or "") + ''
      spa="$out/share/spotify/Apps/xpui.spa"

      if [ ! -f "$spa" ]; then
        echo "patch-spotify: xpui.spa not found at $spa" >&2
        exit 1
      fi

      # Build argument list
      args=(--spa  "$spa")

      ${final.lib.optionalString (theme != null)
        ''args+=(--theme  ${final.lib.escapeShellArg (toString theme)})''}
      ${final.lib.optionalString (colors != null)
        ''args+=(--colors ${final.lib.escapeShellArg (toString colors)})''}
      ${final.lib.concatMapStringsSep "\n" (ext:
        ''args+=(--extension ${final.lib.escapeShellArg (toString ext)})'')
        extensions}

      python3 ${../scripts/patch-spotify.py} "''${args[@]}"
    '';
  });
}
