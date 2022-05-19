with import /home/seb/workspace/nixpkgs { };

let
  python =
    let
      packageOverrides = self: super: {
        # remove opt dependances
        smart-open = super.smart-open.overridePythonAttrs (old: rec {
          propagatedBuildInputs = [
            super.requests
          ];
          doCheck = false;
        });

        my_clickhouse-sqlalchemy = self.callPackage ./clickhouse-sqlalchemy.nix { };
        my_pydeps = self.callPackage ./pydeps.nix { };
        my_cloudpathlib = self.callPackage ./cloudpathlib.nix { };
        webdriver_manager = self.callPackage ./webdriver_manager.nix { };
        mkdocs-jupyter = self.callPackage ./mkdocs-jupyter.nix { };

        wpr = self.callPackage ./cs_package/wpr.nix { };

        aiobotocore = super.aiobotocore.overridePythonAttrs (old: rec {
          version = "2.1.0";
          pname = "aiobotocore";
          src = self.fetchPypi {
            inherit pname version;
            sha256 = "sha256-X9TXrvoIlv5N0ygV6tilLtXMuAFsfFdD/o/3HDwHQSA";
          };
        });

        s3fs = super.s3fs.overridePythonAttrs (old: rec {
          version = "2022.1.0";
          pname = "s3fs";
          src = self.fetchPypi {
            inherit pname version;
            sha256 = "sha256-a6/B9rTpNepZUSwPONXLnCmdu/5zjkDD0d6PZ7TuH9Q";
          };
        }); 

      };
    in
    pkgs.python310.override { inherit packageOverrides; self = python; };

  my-python-packages = python-packages: with python-packages; [
    # package management
    setuptools
    setuptools-scm
    build
    pip
    poetry

    # misc
    notebook
    tqdm
    coloredlogs
    pylint
    my_pydeps
    nbdime

    # documentation
    mkdocs-jupyter
    mkdocs

    # web
    requests
    selenium
    lzstring
    fastapi
    uvicorn
    beautifulsoup4
    httpx
    h2

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
    gensim
    z3
    pyarrow # for .parquet manipulation

    # dataviz
    seaborn
    matplotlib
    bokeh

    # S3 access
    fs-s3fs
    s3fs
    boto3
    my_cloudpathlib

    # work
    wpr

    # security
    pycryptodome
  ];

in
python.withPackages my-python-packages
