{ config, lib, pkgs, ... }:
lib.mkIf config.services.lldap.enable {
	age.secrets.lldap = {
	  file = ../../../secrets/lldap.age;
	  owner = "lldap";
	  group = "lldap";
	};

	services.postgresql = {
	  ensureDatabases = [ "lldap" ];
	  ensureUsers = [{
	    name = "lldap";
	    ensureDBOwnership = true;
	  }];
	};
	services.lldap = {
		# database.type = "postgresql";
		environmentFile = config.age.secrets.lldap.path;
		settings = {
			database_url = "postgresql:///lldap?host=/run/postgresql";
			http_host = "127.0.0.1";
			http_port = 5050;
			http_url  = "https://lldap.wurt.net";
			ldap_base_dn = "dc=wurt,dc=net";
			ldap_host = "127.0.0.1";
			ldap_port = 5051;
			ldap_user_dn = "admin";
			ldap_user_email = "frank.wuerthner@proton.me";
			ldap_user_pass = "39gM17eBhg0p1aeJGz0P1pUMRiyeQi6TkTQqLctXjec=";
			force_ldap_user_pass_reset = "always";
		};
	};
}
