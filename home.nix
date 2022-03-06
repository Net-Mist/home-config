{ config, pkgs, ... }:

let
  zim = import ./custom_pkgs/zim.nix;

  node = pkgs.nodejs-17_x;
  yarn = pkgs.yarn.override {
    nodejs = node;
  };

  python = import ./python;
  pre-commit = pkgs.pre-commit.override {
    python3Packages = python.pkgs;
  };

  multimc = import ./custom_pkgsmultimc.nix;

  gl_stuff = import ./gl_stuff.nix;
  vscode = import ./custom_pkgs/vscode.nix;

  # TODO package in nix
  austin = pkgs.callPackage /home/seb/workspace/nixpkgs/pkgs/development/tools/austin/default.nix { };
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
    pre-commit
    pkgs.hadolint # dockerfile linter
    austin # python profiler
    # vscode

    # needed for pop-shell
    pkgs.nodePackages.typescript

    # tools
    # pkgs.cura
    zim
    pkgs.inkscape
    pkgs.drawio
    pkgs.enlightenment.terminology
    gl_stuff.firefox
    gl_stuff.musescore
    gl_stuff.blender
    pkgs.openvpn
    pkgs.redshift

    # nix tools
    pkgs.nixpkgs-fmt
    pkgs.patchelf
    pkgs.nixpkgs-review


    # security
    # pkgs.snowman
    pkgs.nmap
    pkgs.gobuster
    gl_stuff.burpsuite
    pkgs.metasploit
    pkgs.wireshark
    pkgs.samba
    pkgs.exploitdb

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
  home.file.".config/redshift.conf".source = ./config/redshift.conf;
}
