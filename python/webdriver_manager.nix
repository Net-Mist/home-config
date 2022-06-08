{ buildPythonPackage
, fetchPypi
, pyyaml
, stdlib-list
, requests
, python-dotenv
}:

buildPythonPackage rec {
  pname = "webdriver_manager";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SnJHCGsYHToHen8L5xsvjil9IT3dVj7OomPcsX5Ohl8=";
  };

  propagatedBuildInputs = [
    requests
    python-dotenv
  ];

  doCheck = false;
}
