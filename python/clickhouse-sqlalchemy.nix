# with import <nixpkgs> {};
{ buildPythonPackage
, fetchPypi
, sqlalchemy
, clickhouse-driver
, requests
}:

buildPythonPackage rec {
  pname = "clickhouse-sqlalchemy";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nA5ECcH0gKJFdZcG0pdxFErtFy15YSLZioAsMT25nGM";
  };

  propagatedBuildInputs = [
    sqlalchemy
    clickhouse-driver
    requests
  ];

  doCheck = false;
}
