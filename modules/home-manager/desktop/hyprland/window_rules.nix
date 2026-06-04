[
  {
    match.class = ".*$";
    suppress_event = "maximize";
  }
  {
    match.class = "Zen Browser";
    no_blur = true;
    opacity = 1;
  }
  {
    opacity = 0;
    float = true;
    no_blur = true;
    suppress_event = "activatefocus";
    match = {
      class = "^$";
      title = "^$";
      initial_class = "^$";
      initial_title = "^$";
      pin = false;
      float = true;
      xwayland = true;
      fullscreen = false;
    };
  }
]
