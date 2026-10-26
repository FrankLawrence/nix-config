{ config, lib, pkgs, ... }:
lib.mkIf config.services.jellyfin.enable {
  # Intel N100 (Alder Lake-N) Quick Sync
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API (iHD)
      vpl-gpu-rt # QSV runtime
      intel-compute-runtime # OpenCL, used for HDR tone mapping
    ];
  };
  # GuC/HuC firmware, required for low-power encoding
  boot.kernelParams = [ "i915.enable_guc=3" ];

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  # Libraries are added in the UI: /mnt/video/shows and /mnt/video/movies.
  # Jellyfin only reads the NAS (nas-media-ro), so keep metadata, artwork,
  # subtitles and trickplay images out of the media folders.
  services.jellyfin = {
    openFirewall = true;

    hardwareAcceleration = {
      enable = true;
      type = "qsv";
      device = "/dev/dri/renderD128";
    };

    # Nix is the source of truth for encoding.xml; UI changes to transcoding reset on restart
    forceEncodingConfig = true;
    transcoding = {
      enableHardwareEncoding = true;
      enableIntelLowPowerEncoding = true;
      enableToneMapping = true;
      throttleTranscoding = true;
      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        hevc10bit = true;
        hevcRExt10bit = true;
        hevcRExt12bit = true;
        mpeg2 = true;
        vc1 = true;
        vp9 = true;
        av1 = true;
      };
      # N100 has no AV1 encoder
      hardwareEncodingCodecs.hevc = true;
    };
  };

  systemd.services.jellyfin = {
    after = [ "remote-fs.target" ];
    wants = [ "remote-fs.target" ];
    environment.LIBVA_DRIVER_NAME = "iHD";
  };

  environment.systemPackages = [ pkgs.libva-utils ]; # vainfo, to check the GPU

  custom.glance.monitoredSites = [{
    title = "Jellyfin";
    url = "https://jellyfin.wurt.net";
    check-url = "http://127.0.0.1:8096";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyfin.svg";
  }];
}


