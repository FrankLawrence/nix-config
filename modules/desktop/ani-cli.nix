{ config, pkgs, lib, ... }:

let
    ani-cli = pkgs.ani-cli.overrideAttrs (oldAttrs: rec {
        version = "4.11";
        src = pkgs.fetchFromGitHub {
            owner = "pystardust";
            repo = "ani-cli";
            rev = "v${version}";
            sha256 = "sha256-gQprGtKXXpDm66dFWsrriL4G0NPav+nqm8T6wkdbgk8=";
        };
    });
in
{
    environment.systemPackages = with pkgs; [
        git
        fzf
        mpv
        curl
        aria2
        yt-dlp
        ffmpeg
        ani-skip
        patch
        ani-cli
    ];
}
