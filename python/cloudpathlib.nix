{ buildPythonPackage
, fetchPypi
, boto3
, stdlib-list
}:

buildPythonPackage rec {
  pname = "cloudpathlib";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MLEFqyHLY59CIuFtJLph09klQXgV/wzf8egEC8te7zg=";
  };

  propagatedBuildInputs = [
    boto3
  ];

  doCheck = false;
}
