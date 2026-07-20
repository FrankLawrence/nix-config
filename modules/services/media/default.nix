{ ... }:

{
  imports = [
    ./audiobookshelf.nix
    ./calibre.nix
    ./kavita.nix
    ./komga.nix
    ./navidrome.nix
    ./suwayomi.nix
    ./arr
  ];

  systemd.tmpfiles.rules = [
    "d /media 0755 frank media"
  ];
}
