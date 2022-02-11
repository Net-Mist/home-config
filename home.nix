{ config, pkgs, ... }:

let
  zim = import ./custom_pkgs/zim.nix;
  # my_enchant = pkgs.callPackage /home/seb/workspace/nixpkgs/pkgs/development/libraries/enchant/2.x.nix { };
  # my_pyenchant = pkgs.python3Packages.pyenchant.override {enchant2 = my_enchant; };
  # my_pygtkspellcheck = pkgs.python3Packages.pygtkspellcheck.override {pyenchant = my_pyenchant; };
  # zim = pkgs.zim.overrideAttrs (oldAttrs : {
  #   	propagatedBuildInputs = with pkgs.python3Packages; [ my_pygtkspellcheck pyxdg pygobject3 pkgs.gtksourceview ];
  # });
  # test wrapping Hebrew

  node = pkgs.nodejs-17_x;
  yarn = pkgs.yarn.override {
    nodejs = node;
  };
  multimc = import ./custom_pkgsmultimc.nix;

  python = import ./python;
  gl_stuff = import ./gl_stuff.nix;
  vscode = import ./custom_pkgs/vscode.nix;
in 
{
  home.username = "seb";
  home.homeDirectory = "/home/seb";
  
  home.packages = [
    # dicts
    pkgs.aspellDicts.fr
    pkgs.aspellDicts.en-computers
    pkgs.aspellDicts.en-science 

    # fonts
    pkgs.powerline-fonts
  
    # dev
    pkgs.htop
    pkgs.git
    pkgs.gitg
    node
    yarn
    python
    pkgs.pre-commit
    pkgs.hadolint # dockerfile linter
    # vscode

    # needed for pop-shell
    pkgs.nodePackages.typescript
        
    # tools
    zim
    # pkgs.snowman
    # pkgs.cura
    pkgs.patchelf
    pkgs.inkscape
    pkgs.drawio
    pkgs.enlightenment.terminology
    gl_stuff.firefox
    gl_stuff.musescore
    pkgs.blender
    
    # game
    # multimc
  ];

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  
  # program configurations
  home.file.".gitconfig".source = ./config/gitconfig;
  home.file.".gitconfig-work".source = ./config_secret/gitconfig-work;
  home.file.".gitconfig-private".source = ./config_secret/gitconfig-private;
  home.file.".config/htop/htoprc".source = ./config/htoprc;

  # these files were generated with `ipython profile create`
  home.file.".ipython/profile_default/ipython_config.py".source = ./config/ipython_config.py;
  home.file.".ipython/profile_default/ipython_kernel_config.py".source = ./config/ipython_kernel_config.py;
  
}
