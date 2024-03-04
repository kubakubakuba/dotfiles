#inherited from https://www.reddit.com/r/NixOS/comments/1706v6p/vs_code_with_jupyter_on_nixos/

with import <nixpkgs> { };

let
  pythonPackages = python311Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  venvDir = "./.venv";
  buildInputs = [
    pkgs.stdenv.cc.cc.lib
    git-crypt
    pythonPackages.ipython
    pythonPackages.ipykernel
    pythonPackages.jupyterlab
    pythonPackages.pyzmq
    pythonPackages.venvShellHook
    pythonPackages.pip
    pythonPackages.numpy
    pythonPackages.pandas
    pythonPackages.requests
    pythonPackages.notebook
    pythonPackages.jupyter
    openssl
    libzip
    zlib
  ];

  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    python -m ipykernel install --user --name=myenv4 --display-name="myenv4"
    pip install -r requirements.txt
  '';
}
