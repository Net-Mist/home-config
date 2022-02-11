with import <nixpkgs> {};

# look for https://nixpk.gs/pr-tracker.html?pr=152307 for python3.10.1 adaptation
let
  python = let
    packageOverrides = self: super: {
      # see https://github.com/NixOS/nixpkgs/pull/154290/files
      ipykernel = super.ipykernel.overridePythonAttrs(old: rec {
        # remove debugpy
        propagatedBuildInputs = [
          self.ipython
          self.jupyter-client
          self.tornado
          self.traitlets
        ];

        postPatch = ''
          substituteInPlace setup.py \
            --replace "'debugpy>=1.0.0,<2.0'," ""
        '';
      });

      s3fs = super.s3fs.overridePythonAttrs(old: rec {
        version = "2021.11.0";
        src =  super.fetchPypi {
          pname = "s3fs";
          inherit version;
          sha256 = "sha256-PCPqwfpbaFydUHlQsk91kp6LzR6pi5qVzyqctm7myfU=";
        };
        doCheck = false;
      });

      # update version of fsspec for s3fs
      fsspec = super.fsspec.overridePythonAttrs(old: rec {
        version = "2021.11.0";
        src =  super.fetchPypi {
          pname = "fsspec";
          inherit version;
          sha256 = "sha256-y7e6/VmqM2hKkuhDh39K3AEJ+wcisaJufQj1puJQCQQ=";
        };
        doCheck = false;
      });

      # fix version of SQLAlchemy for clickhouse
      sqlalchemy = super.sqlalchemy.overridePythonAttrs(old: rec {
        version = "1.3.24";
        src = super.fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          sha256 = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
      });

      # fix version of databases because of SQLAlchemy 
      databases = super.databases.overridePythonAttrs(old: rec {
        version = "0.4.3";
        src = super.fetchPypi {
          pname = "databases";
          inherit version;
          sha256 = "sha256-FSHbf208WB/4GzVS4TCyehOu/qKlcpXmVzgIGDETevw=";
        };
        doCheck = false;
      });
      # use 
        #     src = fetchFromGitHub {
        #   owner = "boto";
        #   repo = pname;
        #   rev = version;
        #   hash = "sha256-0Dl7oKB2xxq/a8do3HgBUIGay88yOGBUdOGo+QCtnUE=";
        # };
    };
  in pkgs.python310.override {inherit packageOverrides; self = python;};

  my_clickhouse-sqlalchemy = import ./clickhouse-sqlalchemy.nix;

  my-python-packages = python-packages: with python-packages; [
    setuptools
    build
    pip
    tqdm
    coloredlogs
    notebook
    pylint

    # web
    requests
    selenium
    lzstring
    fastapi
    uvicorn
    beautifulsoup4

    # image
    pillow
    opencv4

    # Database
    sqlalchemy
    psycopg2
    my_clickhouse-sqlalchemy

    # computation
    cython
    numpy
    pandas
    scikit-learn
    z3
    pyarrow # for .parquet manipulation

    # dataviz
    seaborn
    matplotlib

    # S3 access
    fs-s3fs
    s3fs
    boto3
  ]; 

in
  python.withPackages my-python-packages

