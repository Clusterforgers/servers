{ self, ... }: {
  flake.nixosModules.queen-configuration = { config, pkgs, ... }: {
    imports = [ self.nixosModules.queen-hardware ];

    networking.hostName = "queen";
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

    users.users.root.shell = pkgs.fish;
  };
}
