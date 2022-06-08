{ buildPythonPackage
, fetchPypi
, boto3
, stdlib-list
}:

buildPythonPackage rec {
  pname = "cloudpathlib";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SIX1JXaFrrjhSYTcyczau+dS2RkJFfpsLijJXlcwzLE=";
  };

  propagatedBuildInputs = [
    boto3
  ];

  doCheck = false;
}
