{ config, lib, ... }:
lib.mkIf config.services.lldap.enable {
  age.secrets = {
    lldap-user = {
      file = ../../../secrets/lldap-user.age;
      owner = "lldap";
      group = "lldap";
    };
    lldap = {
      file = ../../../secrets/lldap.age;
      owner = "lldap";
      group = "lldap";
    };
  };

  users.users.lldap = {
    isSystemUser = true;
    group = "lldap";
  };
  users.groups.lldap = { };
  systemd.services.lldap.serviceConfig.DynamicUser = lib.mkForce false;

  services.postgresql = {
    ensureDatabases = [ "lldap" ];
    ensureUsers = [
      {
        name = "lldap";
        ensureDBOwnership = true;
      }
    ];
  };
  services.lldap = {
    environmentFile = config.age.secrets.lldap.path;
    settings = {
      database_url = "postgresql:///lldap?host=/run/postgresql";
      http_host = "127.0.0.1";
      http_port = 5050;
      http_url = "https://lldap.wurt.net";
      ldap_base_dn = "dc=wurt,dc=net";
      ldap_host = "127.0.0.1";
      ldap_port = 5051;
      ldap_user_dn = "admin";
      ldap_user_email = "admin@wurt.net";
      ldap_user_pass_file = config.age.secrets.lldap-user.path;
      force_ldap_user_pass_reset = "always";
    };
  };
}
