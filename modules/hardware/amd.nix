{ config, pkgs, inputs, lib, ... }:
{
  # Enable HIP libraries for GPU rendering
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Settings for running folding@home
  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkForce false;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
    ];
  };
}
