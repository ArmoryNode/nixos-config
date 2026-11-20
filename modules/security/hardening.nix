{ lib, ... }: {
  # Only let wheel users talk to the Nix daemon
  nix.settings.allowed-users = [ "@wheel" ];

  # Wipe /tmp on every boot
  boot.tmp.cleanOnBoot = true;

  # Enable sudo-rs and restrict execution to wheel users only
  security.sudo-rs.enable = true;
  security.sudo-rs.execWheelOnly = true;

  # Enable AppArmor
  security.apparmor.enable = true;

  # Use the D-Bus broker implementation
  services.dbus.implementation = "broker";

  # Log refused firewall connections
  networking.firewall.logRefusedConnections = true;
  
  # Apply kernel hardening sysctl settings
  boot.kernel.sysctl = {
    # Hide kernel pointers and the kernel log from unprivileged users
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;

    # Lock down BPF
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;

    # Block TTY line-discipline autoloading
    "dev.tty.ldisc_autoload" = 0;

    # Safer handling of FIFOs and files in shared directories, and no setuid core dumps
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = 0;

    # More ASLR entropy
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_rnd_compat_bits" = 16;

    # Network: ignore ICMP redirects and source routing
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
  };

  # Block kexec and hibernation (hosts can override this)
  security.protectKernelImage = lib.mkDefault true;

  # Memory-safety kernel parameters
  boot.kernelParams = [
    "slab_nomerge"
    "init_on_alloc=1"
    "page_alloc.shuffle=1"
    "randomize_kstack_offset=on"
    "vsyscall=none"
  ];

  # Blacklist potentially unsafe or unnecessary kernel modules
  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25" "netrom" "rose"

    # Obsolete or rarely used network protocols
    "dccp" "sctp" "rds" "tipc" "n-hdlc" "x25" "decnet" "econet" "af_802154" "ipx" "appletalk" "atm" "can"
    "firewire-core" "firewire-ohci" "firewire-sbp2"
    "vivid"

    # Old or rare or insufficiently audited filesystems
    "adfs" "affs"
    "bfs" "befs"
    "cramfs"
    "efs" "erofs" "exofs"
    "freevxfs" "f2fs"
    "hfs" "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "omfs"
    "qnx4" "qnx6"
    "sysv"
    "ufs"
  ];
}