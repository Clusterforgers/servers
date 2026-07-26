# Clusterforgers Servers

Deployable NixOS host configs for every machine in the cluster. Each host directory under `modules/` (e.g. `modules/oracle/`) defines a `nixosModules.<host>-configuration`, a `nixosModules.<host>-hardware`, and a `nixosConfigurations.<host>` that wires in the shared cluster modules from [`Clusterforgers/k3s-cluster`](https://github.com/Clusterforgers/k3s-cluster).

This repo is the actual rebuild target — see that repo's README for the full bootstrap/operate workflow (`rebuild-<name>`, `update-<name>`, adding a node, etc). This one just holds host-specific config: hostname, hardware, and which role (`kubernetes-server` / `kubernetes-agent`) the host plays.

## Secrets

Nothing secret is committed here. Each host's `default.nix` reads `secrets.nix` from a path you provide via the `NIXOS_SECRETS_PATH` environment variable, e.g.:

```sh
export NIXOS_SECRETS_PATH=~/nixos/secrets.nix
```

`secrets.nix` must evaluate to an attrset with at least:

```nix
{
  sshKeys = [ "ssh-ed25519 AAAA... you" "ssh-ed25519 AAAA... your-friend" ];
  githubRunnerToken = "...";
}
```

Both operators' SSH public keys need to be in `sshKeys` — that's what ends up in each server's `authorized_keys` for the key-based build/rebuild path (see the network model in the `k3s-cluster` README for why that's separate from Tailscale SSH).

## Adding a new host

1. Create `modules/<host>/{hardware,configuration,default}.nix` following the `oracle` example.
2. Add the host to `k3s-cluster`'s `modules/cluster-vars.json`.
3. Follow the bootstrap steps in the `k3s-cluster` README.
