{ self, ... }: {
  flake.nixosModules.bullet-hardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.initrd.availableKernelModules = [ "xhci-pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/"     = { device = "/dev/disk/by-uuid/6f0c8938-da5d-4dd1-b841-f79b2814cf48"; 
                            fsType = "ext4"; };
    fileSystems."/boot" = { device = "/dev/disk/by-uuid/736E-2F32"; 
                            fsType = "vfat"; 
                            options = [ "umask=0077" "dmask=0077" ]; };
    swapDevices = [  ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributionFirmware;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
