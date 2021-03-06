with import <nixpkgs> { };

{
  blender = pkgs.symlinkJoin {
    name = "blender";
    paths = [ pkgs.blender ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/blender \
      --prefix LD_LIBRARY_PATH : /home/seb/nixfiles/libgl
    '';
  };

  firefox = pkgs.symlinkJoin {
    name = "firefox";
    paths = [ pkgs.firefox-wayland ]; # see https://github.com/NixOS/nixpkgs/issues/77995
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/firefox \
      --prefix LD_LIBRARY_PATH : /home/seb/nixfiles/libgl
    '';
  };

  musescore = pkgs.symlinkJoin {
    name = "musescore";
    paths = [ pkgs.musescore ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/musescore \
      --prefix LD_LIBRARY_PATH : /home/seb/nixfiles/libgl
    '';
  };

  burpsuite = pkgs.symlinkJoin {
    name = "burpsuite";
    paths = [ pkgs.burpsuite ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/burpsuite \
      --prefix LD_LIBRARY_PATH : /home/seb/nixfiles/libgl
    '';
  };

  sweethome3d = pkgs.symlinkJoin {
    name = "sweethome3d";
    paths = [ pkgs.sweethome3d.application ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/sweethome3d \
      --prefix LD_LIBRARY_PATH : /home/seb/nixfiles/libgl
    '';
  };
}
