{ config, lib, pkgs, ... }: {
  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  boot.initrd.kernelModules = [ "kvmfr" ];
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "kvmfr.static_size_mb=64"
  ];

  services.udev.packages = lib.singleton (pkgs.writeTextFile {
    name = "kvmfr";
    text = ''
      SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
    '';
    destination = "/etc/udev/rules.d/70-kvmfr.rules";
  });

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      verbatimConfig = ''
        namespaces = []
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
          "/dev/rtc", "/dev/hpet", "/dev/vfio/vfio",
          "/dev/kvmfr0"
        ]
      '';
    };
  };

  environment.systemPackages = [ pkgs.looking-glass-client ];

  programs.virt-manager.enable = true;
}
