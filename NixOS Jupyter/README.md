# Jupyter on NixOS

Run nix-shell in the same folder, where the nix config file is placed `default.nix`.
In there, change the required packages (change the pip packages in `requirements.txt`).

Run `nix-shell` (which creates the venv), then you can normally open code via `code .`. The jupyter kernel should be named `myevn4`.

[source - r/NixOS](https://www.reddit.com/r/NixOS/comments/1706v6p/vs_code_with_jupyter_on_nixos/)