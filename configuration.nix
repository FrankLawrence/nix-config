{ pkgs, ... }:
 
 {
   nix.settings = {
     experimental-features = "nix-command flakes";
   };
   
   environment.systemPackages = [
     pkgs.neovim
     pkgs.git
   ];
   
   fileSystems."/" = {
     device = "/dev/disk/by-label/nixos";
     fsType = "ext4";
   };
   fileSystems."/boot" = {
     device = "/dev/disk/by-label/boot";
     fsType = "ext4";
   };
   swapDevices = [
     {
       device = "/dev/disk/by-label/swap";
     }
   ];

   systemd.network.enable = true;
   systemd.network.networks."30-wan" = {
     matchConfig.Name = "enp1s0";
     networkConfig.DHCP = "ipv4";
     address = [
       "2a01:4f9:c012:d8e::1/64"
     ];
     routes = [
       { Gateway = "fe80::1"; }
     ];
   };
   
   time.timeZone = "Europe/Helsinki";
   i18n.defaultLocale = "en_US.UTF-8";
   console.keyMap = "us";
   
   boot.loader.grub.enable = true;
   boot.loader.grub.device = "/dev/sda";
   boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];
   
   users.users = {
     root.hashedPassword = "!"; # Disable root login
     pinkfloyd = {
       isNormalUser = true;
       extraGroups = [ "wheel" ];
       openssh.authorizedKeys.keys = [
         "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7FOWFMAX2lRpfic/yDN4JDMHs6jANJAeuH0DTQ03X0xs6JLRWdmsPz7ltIgVjhcwAqJeP9nNL2HRWholEK5bGgTCmT3tZtDgEAMm9kXw0BiKKlMRsuJKu2JypyGY8OCTD9yaY2oGQa3o2puZZMvJ/vHZJ+Wuw1J9ZiNiCqsBxy+ntHuJOISAOmYCT9j8O7giT5wXHP5+RW7nrYtH8dZTMmvNM/eVzwYYF8WVBdUw0GtgQn9zeNcPBlqYfrOyyFZ2aAF3zi3qc8BvR5FKiPyWJmLy9JPVePUerG5Jqfg2czUdYtfUMPDYJHZ7QEOiUNWDzAvHrgpuwET0DYo1R7obnFgHu2VbxX5j2dQglcgRm1B5BSpniUs5K0T5eVUiFjdHaYC1IY0XjeiMs58npQjAiuxzYUygiiAMU8xExzxVnpHkjSuCRFsBryxMuZu4Zb9epu/DCps3JdITCNmc11HCNTEazPjC+u34zETGvzRcP1V/TSapFjFSHmXuuxhyGjS7V9KCCA/QSyo3IxB8mrFmu2SuRFgHJfnZwMImjZ0wq+Sbf8O0SXT+44z6paRGAF7DyFEywf4BV6P+E8ePSgpRxvBiVl/eJix+y/jzKHniMs7+DfO+Aw0ZQjy2Q4SvGXtCOfAoWxJFCGt1h8OoMyYu9HDJIe2DVMSU6aYjocn1UiQ== pinkfloyd"
       ];
     };
   };
   
   security.sudo.wheelNeedsPassword = false;
   
   services.openssh = {
     enable = true;
     settings = {
       PermitRootLogin = "no";
       PasswordAuthentication = false;
       KbdInteractiveAuthentication = false;
     };
   };
   
   networking.firewall.allowedTCPPorts = [ 22 ];
   
   system.stateVersion = "24.11";
 }
