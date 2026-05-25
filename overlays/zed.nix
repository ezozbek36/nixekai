final: prev: {
  zed-editor = prev.zed-editor.overrideAttrs (oldAttrs: {
    doCheck = false;

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [final.mold];

    env =
      (oldAttrs.env or {})
      // {
        RUSTFLAGS = "-C target-cpu=alderlake -C opt-level=3 -C codegen-units=1 -C link-arg=-fuse-ld=mold";
      };
  });
}
