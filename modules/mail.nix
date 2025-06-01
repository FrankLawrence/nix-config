{ config, pkgs, ... }: {
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-24.11/nixos-mailserver-nixos-24.11.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-24.11"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "0lgrqdgb4z45ng875pa47m2vm7p3hhxn4n80x9z4qwvcdrrxrgch";
    })
  ];

  mailserver = {
    enable = true;
    stateVersion = "24.11";
    fqdn = "mail.wurt.net";
    domains = [ "wurt.net" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "frank@wurt.net" = {
        hashedPasswordFile = "/etc/secrets/mail_hash";
        aliases = ["postmaster@wurt.net"];
      };
    };

    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@wurt.net";
}
