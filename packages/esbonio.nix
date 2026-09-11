{
  lib,
  fetchPypi,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "esbonio";
  version = "2.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f9aXNhbIhomAD/PeF86SnG3+NP7fbiwULit86riy670=";
  };

  pyproject = true;
  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiosqlite
    docutils
    platformdirs
    pygls
    websockets
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A language server for working with Sphinx projects";
    homepage = "https://github.com/swyddfa/esbonio";
    changelog = "https://github.com/swyddfa/esbonio/releases/tag/esbonio-language-server-v2.1.0";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "esbonio";
    platforms = lib.platforms.all;
  };
}
