# with import <nixpkgs> {};
{ buildPythonPackage
, fetchPypi
, pyyaml
, stdlib-list
}:

buildPythonPackage rec {
  pname = "pydeps";
  version = "1.10.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cSpEohH0e5taH/bpjidl7T+6+SbBlOpggdSJN4bFduw=";
  };

  propagatedBuildInputs = [
    pyyaml
    stdlib-list
  ];

  doCheck = false;
}
