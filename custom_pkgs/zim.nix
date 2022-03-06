with import <nixpkgs> { };

# create a custom spell checker for french and english. And with Hebrew removed....
# issue : https://github.com/NixOS/nixpkgs/issues/152981

let
  my_enchant = pkgs.enchant.overrideAttrs (oldAttrs: { propagatedBuildInputs = [ pkgs.aspell ]; });
  my_pyenchant = pkgs.python3Packages.pyenchant.override { enchant2 = my_enchant; };
  my_pygtkspellcheck = pkgs.python3Packages.pygtkspellcheck.override { pyenchant = my_pyenchant; };
in
pkgs.zim.overrideAttrs (oldAttrs: {
  propagatedBuildInputs = with pkgs.python3Packages; [ my_pygtkspellcheck pyxdg pygobject3 pkgs.gtksourceview ];
})

