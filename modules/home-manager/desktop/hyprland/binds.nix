{lib, ...}: [
  {
    _args = [
      (lib.generators.mkLuaInline ''mod .. " + T"'')
      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd(terminal)'')
    ];
  }
  {
    _args = [
      (lib.generators.mkLuaInline ''mod .. " + D"'')
      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("rofi -show drun")'')
    ];
  }
]
