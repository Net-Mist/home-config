{ buildPythonPackage
, fetchPypi
, pyyaml
, stdlib-list
, requests
, nbconvert
, jupytext
, mkdocs 
, mkdocs-material
}:

buildPythonPackage rec {
  pname = "mkdocs-jupyter";
  version = "0.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O272de4vIq2UBH23+E4hL1J4Up32WfdYS1orhmLbOfY=";
  };

  propagatedBuildInputs = [
    nbconvert
    jupytext
    mkdocs 
    mkdocs-material
  ];

  doCheck = false;
}
