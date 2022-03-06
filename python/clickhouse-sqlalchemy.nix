{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, sqlalchemy
, clickhouse-driver
, requests
, nose
, parameterized
, responses
}:

buildPythonPackage rec {
  pname = "clickhouse-sqlalchemy";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "xzkostyan";
    repo = "clickhouse-sqlalchemy";
    rev = version;
    hash = "sha256-lkRSc2vREL67+wNY4hSaZef2/TeNgdu4sdYiv/rPTvw";
  };

  propagatedBuildInputs = [
    sqlalchemy
    clickhouse-driver
    requests
  ];

  checkInputs = [
    nose
    parameterized
    responses
  ];

  # tests require a clickhouse database running in localhost.
  # see docker-compose file in tests dir
  doCheck = false;

  meta = with lib; {
    description = "ClickHouse dialect for SQLAlchemy ";
    homepage = "https://github.com/xzkostyan/clickhouse-sqlalchemy";
    license = licenses.mit;
    maintainers = with maintainers; [ net-mist ];
  };
}
