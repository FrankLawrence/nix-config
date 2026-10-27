let
  devices = {
    astra = {
      id = "KTXIFY2-EFU5OYR-3SZ2ERM-CXV6M3I-LR5DAFU-Z2ERSGA-CXBHXKD-XDTPTQT";
    };
    centauri = {
      id = "FM2A7X5-FGB4MNL-AWQLUZA-YOCWXB5-RFM4J2V-G6PQXWQ-U7QHVQN-IAXYXAG";
      addresses = [
        "tcp://192.168.178.128:22000"
        "dynamic"
      ];
    };
    # jupiter = {
    #   # Run `syncthing device-id` on jupiter (or Actions -> Show ID in its GUI)
    #   id = "<jupiter device id>";
    # };
    terra = {
      id = "QJXO57G-AJVI2DV-T3L4VTI-CTSKCVP-2NU5K3D-DZ5VEKY-ZPOPV5O-TU4YTAM";
    };
  };

  allDevices = builtins.attrNames devices;
in
{
  devices = builtins.mapAttrs (name: d: d // { inherit name; }) devices;

  folders = {
    nb = {
      id = "nb";
      label = "nb";
      path = "~/.nb";
      devices = allDevices;
    };
    Sync = {
      id = "detau-kqjgw";
      label = "Sync";
      path = "~/Sync";
      devices = allDevices;
      versioning = {
        type = "staggered";
        params = {
          cleanInterval = "3600";
          maxAge = "15552000"; # 180 days
        };
      };
    };
  };
}
