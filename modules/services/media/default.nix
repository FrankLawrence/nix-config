{ ... }:

{
  imports = [
    ./audiobookshelf.nix
    ./calibre.nix
    ./kavita.nix
    ./komga.nix
    ./navidrome.nix
    ./arr
  ];

  systemd.tmpfiles.rules = [
    "d /media 0755 frank media"
  ];
}
