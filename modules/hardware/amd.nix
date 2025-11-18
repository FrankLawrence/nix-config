{ config, pkgs, inputs, ... }:
{
  # Enable HIP libraries for GPU rendering
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

}
