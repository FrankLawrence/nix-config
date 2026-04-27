{ ... }:

{
  imports = [
    # ./kavita.nix
    # ./komga.nix
    ./navidrome.nix
  ];

  systemd.tmpfiles.rules = [
    "d /media 0755 frank media"
    # "d /home/frank/Music 0755 frank media"
  ];
}
