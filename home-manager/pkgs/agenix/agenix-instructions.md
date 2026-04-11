# Setting up Agenix on a new computer

- comment out the `homeActivation` section of `agenix.nix` and do a home manager rebuild
- run `ssh-keygen`, and save the key to `~/.ssh/id_ed25529_github` (expand `~`)
- add a new entry into `agenix-secrets.nix` with the public key
- un-comment the `homeActivation` section and rebuild

- something is not right here, the rebuild gets to agenix and then stops building anything. I suspect this is related to the fact that I haven't set up an ssh key that can be used to _access_ the agefile, but I'm not sure.
