{ self, ... }: {
  flake.nixosModules.queen-configuration = { config, pkgs, ... }: {
    imports = [ self.nixosModules.queen-hardware ];

    networking.hostName = "queen";
    networking.firewall.allowedTCPPorts = [ 80 443 25565 7881 ];
    # ARK: 7777 game, 7778 (game+1, used internally by the engine), 27015 Steam
    # query. RCON (32330) is deliberately left closed — it doubles as the
    # in-game admin password, reach it over tailscale0 instead.
    networking.firewall.allowedUDPPorts = [ 7777 7778 27015 ];
    # Stoat voice/video (LiveKit, hostNetwork): 7881 above is RTC over TCP, 50000-50100
    # RTC over UDP. Signalling (7880) is only opened to pods on this node,
    # which reach it through the `livekit` Service; the public gets it via
    # the ingress at wss://stoat.hivemindcloud.dk/livekit.
    networking.firewall.allowedUDPPortRanges = [ { from = 50000; to = 50100; } ];
    networking.firewall.interfaces.cni0.allowedTCPPorts = [ 7880 ];
    system.stateVersion = "25.05";

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      fastfetch
    ];

    boot.kernelParams = [ "nomodeset" ];
    boot.swraid.enable = true;
    boot.swraid.mdadmConf = ''
      ARRAY /dev/md0 metadata=1.2 UUID=3431715b:c41f02d8:d6bfe81b:4b9678d8
      MAILADDR root
    '';

    fileSystems."/mnt/data" = {
      device = "/dev/disk/by-uuid/400dfe4c-a9fa-4316-8f94-0e45c5a9fb8d";
      fsType = "ext4";
      options = [ "nofail" "x-systemd.device-timeout=30s" ];
    };

    # Dedicated game-server disk (sdb, 366G), registered with Longhorn under the
    # `games` disk tag. Keeps ARK off both the 3.6T /mnt/data array and the OS
    # disk. Previously held an old AMP panel install; reformatted 2026-07-31.
    fileSystems."/mnt/games" = {
      device = "/dev/disk/by-uuid/e971d854-f52f-4f6a-a964-3addeac2a97e";
      fsType = "ext4";
      options = [ "nofail" "x-systemd.device-timeout=30s" ];
    };

    users.users.root.shell = pkgs.fish;
  };
}
