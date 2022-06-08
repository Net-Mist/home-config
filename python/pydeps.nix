{ buildPythonPackage
, fetchPypi
, pyyaml
, stdlib-list
}:

buildPythonPackage rec {
  pname = "pydeps";
  version = "1.10.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1RL28JhJR6RVU1mHmM3yKaSiOiwTier2ATlBamj87F8=";
  };

  propagatedBuildInputs = [
    pyyaml
    stdlib-list
  ];

  doCheck = false;
}
