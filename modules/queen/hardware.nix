{ self, ... }: {
  flake.nixosModules.queen-hardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "usbhid" "sd_mod" "aacraid" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    # Legacy BIOS boot — GRUB to the MBR of the 360G controller boot volume (sdc).
    boot.loader.grub = {
      enable = true;
      device = "/dev/disk/by-id/scsi-2377a3ab000d00000";
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/98420fa7-c7b7-4d03-8bb0-d26ea7d89124";
      fsType = "ext4";
    };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.enableRedistributableFirmware = lib.mkDefault true;
  };
}