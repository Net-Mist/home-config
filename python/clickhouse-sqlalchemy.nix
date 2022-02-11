with import <nixpkgs> {};


python.pkgs.buildPythonPackage rec {
  pname = "clickhouse-sqlalchemy";
  version = "0.1.7";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-/5ta943gb7dAhexNJ6YLO1hzP8RLDpcTxTiiqo+Dxeg=";
  };

  propagatedBuildInputs = with python.pkgs; [
    sqlalchemy
    clickhouse-driver
    requests
  ];

  doCheck = false;
}
