with import <nixpkgs> {};

let
  libpath = with pkgs.xorg; pkgs.lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm pkgs.libpulseaudio pkgs.libGL ];
  msaClientID = "499546d9-bbfe-4b9b-a086-eb3d75afb78f";
in
  pkgs.multimc.overrideAttrs (oldAttrs : {
    version = "custom-2021-12-25";
    src = pkgs.fetchFromGitHub {
      owner = "MultiMC";
      repo = "Launcher";
      rev = "0.6.14";
      sha256 = "sha256-7tM+z35dtUIN/UioJ7zTP8kdRKlTJIrWRkA08B8ci3A=";
      fetchSubmodules = true;
    };
    cmakeFlags = [ "-DLauncher_LAYOUT=lin-nodeps" ];
    
    preFixup = ''
      mkdir -p $out/lib
      mv $out/bin/*.so $out/lib/
    '';

    postPatch = ''
      # hardcode jdk paths
      substituteInPlace launcher/java/JavaUtils.cpp \
        --replace 'scanJavaDir("/usr/lib/jvm")' 'javas.append("${pkgs.jdk}/lib/openjdk/bin/java")' \
        --replace 'scanJavaDir("/usr/lib32/jvm")' 'javas.append("${pkgs.jdk8}/lib/openjdk/bin/java")'
      # add client ID
      substituteInPlace notsecrets/Secrets.cpp \
        --replace 'QString MSAClientID = "";' 'QString MSAClientID = "${msaClientID}";'
    '';

    postInstall = ''
      install -Dm644 ../launcher/resources/multimc/scalable/launcher.svg $out/share/pixmaps/launcher.svg
      
      # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      wrapProgram $out/bin/DevLauncher \
        --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xorg.xrandr ]} \
        --add-flags '-d "''${XDG_DATA_HOME-$HOME/.local/share}/DevLauncher"'
    '';
  })

