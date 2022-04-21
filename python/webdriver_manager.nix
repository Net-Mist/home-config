{ buildPythonPackage
, fetchPypi
, pyyaml
, stdlib-list
, requests
}:

buildPythonPackage rec {
  pname = "webdriver_manager";
  version = "3.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LrfC/jjsWwbiCQFkkj5N+3w6xOcUAzOj3px5VvUEeFg=";
  };

  propagatedBuildInputs = [
    requests
  ];

  doCheck = false;
}
