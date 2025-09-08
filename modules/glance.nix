{ config, pkgs, ... }:

{
  age.secrets.adguard = {
    file = ../secrets/adguard.age;
  };

  services.glance = {
    enable = true;
    settings = {
      server = {
        port = 8084;
        host = "0.0.0.0";
      };
      pages = [
      {
        name = "Home";
        center-vertically = true;
        columns = [
        {
          size = "small";
          widgets = [
          {
            type = "calendar";
          }
          {
            type = "rss";
            limit = 10;
            collapse-after = 3;
            cache = "3h";
            feeds = [
            { url = https://ciechanow.ski/atom.xml; }
            {
              url = https://www.joshwcomeau.com/rss.xml;
              title = "Josh Comeau";
            }
            { url = https://samwho.dev/rss.xml; }
            { url = https://awesomekling.github.io/feed.xml; }
            {
              url = https://isadeed.com/feed.xml;
              title = "Ahmad Shadeed";
            }
            { url = https://weekly.nixos.org/feeds/all.rss.xml; }
            ];
          }
          ];
        }
        {
          size = "full";
          widgets = [
          {
            type = "search";
            autofocus = true;
            bangs = [
            {
              title = "Youtube";
              shortcut = "!yt";
              url = "https://www.youtube.com/results?search_query={QUERY}";
            }
            {
              title = "Urban Dictionary";
              shortcut = "!urb";
              url = "https://www.urbandictionary.com/define.php?term={QUERY}";
            }
            {
              title = "Image Search";
              shortcut = "!i";
              url = "https://duckduckgo.com/?iar=images?q={QUERY}";
            }
            {
              title = "Searx";
              shortcut = "!s";
              url = "https://searxng.site/searxng/search?q={QUERY}";
            }
            ];
          }
          {
            type = "group";
            widgets = [
            { type = "hacker-news"; }
            {
              type = "videos";
              style = "grid-cards";
              video-url-template = "https://yewtu.be/watch?v={VIDEO-ID}";
              channels = [
                "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                  "UCdBK94H6oZT2Q7l0-b0xmMg" # Short circuit
                  "UCeeFfhMcJa1kjtfZAGskOCA" # TechLinked

                  # Homelab
                  "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                  "UCsnGwSIHyoYN0kiINAGUKxg" # Wolfgang Channel
                  "UCZNhwA1B5YqiY1nLzmM0ZRg" # Christian Lempa
                  "UCgdTVe88YVSrOZ9qKumhULQ" # Hardware Haven

                  # 3D Print and Homelab
                  "UCmlzNHg8QiWVutUyFOV2UdQ" # Thestockpot

                  "UC7YOGHUfC1Tb6E4pudI9STA" # Mental Outlaw
                  "UC9x0AN7BWHpCDHSm9NiJFJQ" # Networkchuck

                  "UCWQaM7SpSECp9FELz-cHzuQ" # Dreams of Code
                  "UC04nROIJrY22Gl2aFqKcdqQ" # Sylivan Frank
                  "UCUMwY9iS8oMyWDYIe6_RmoA" # No boilerplate
                  "UCuGS5mN1_CpPzuOUAu2LluA" # Nixhero
                  "UC_zBdZ0_H_jn41FDRG7q4Tw" # Vimjoyer
                  ];
            }
            ];
          }
          ];
        }
        {
          size = "small";
          widgets = [
          {
            type = "weather";
            location = "Zurich";
          }
          ];
        }
        ];
      }
      {
        name = "Self Hosting";
        center-vertically = true;
        columns = [
        {
          size = "small";
          widgets = [
            {
              type = "dns-stats";
              service = "adguard";
              url = "https://adguard.wurt.net/";
              username = "pinkfloyd";
              password = config.age.secrets.adguard.path;
            }
            {
              type = "rss";
              limit = 10;
              collapse-after = 3;
              cache = "3h";
              feeds = [
              {
                url = "https://selfh.st/rss/";
                title = "This Week in Self-Hosted";
              }
              ];
            }
            # {
            #   type = "releases";
            #   show-source-icon = true;
            #   respositories = [
            #     "jellyfin/jellyfin"
            #     "glanceapp/glance"
            #   ];
            # }
          ];
        }
        {
          size = "full";
          widgets = [
          {
            type = "monitor";
            cache = "1m";
            title = "Services";
            sites = [
            {
              title = "Nginx Proxy Manager";
              url = "https://wurt.net";
              check-url = "http://192.168.178.154:81";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/nginx-proxy-manager.svg";
            }
            {
              title = "Jellyfin";
              url = "https://jellyfin.wurt.net";
              check-url = "http://localhost:8096";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyfin.svg";
            }
            {
              title = "Immich";
              url = "https://immich.wurt.net";
              check-url = "http://localhost:2283";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg";
            }
            {
              title = "AdGuard Home";
              url = "https://adguard.wurt.net";
              check-url = "http://192.168.178.158:80";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/adguard-home.svg";
            }
            {
              title = "Home Assistant";
              url = "https://ha.wurt.net";
              check-url = "http://192.168.178.207:8123";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/home-assistant.svg";
            }
            {
              title = "Wire Guard";
              url = "https://wg.wurt.net";
              check-url = "http://192.168.178.159:10086";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/wireguard.svg";
            }
            {
              title = "Linkwarden";
              url = "https://linkwarden.wurt.net";
              check-url = "http://192.168.178.161:3000";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/linkwarden.png";
            }
            {
              title = "Vikunja";
              url = "https://vikunja.wurt.net";
              check-url = "http://192.168.178.164:3456";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/vikunja.png";
            }
            {
              title = "Navidrome";
              url = "https://navidrome.wurt.net";
              check-url = "http://localhost:4533";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/navidrome.svg";
            }
            {
              title = "komga";
              url = "https://komga.wurt.net";
              check-url = "http://localhost:8082";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/komga.svg";
            }
            {
              title = "Kavita";
              url = "https://kavita.wurt.net";
              check-url = "http://localhost:5000";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/kavita.svg";
            }
            {
              title = "Stirling PDF";
              url = "https://stirling-pdf.wurt.net";
              check-url = "http://localhost:8080";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/stirling-pdf.svg";
            }
            {
              title = "Synology NAS";
              url = "https://synology.wurt.net";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/synology.svg";
            }
            {
              title = "Paperless NGX";
              url = "https://paperless.wurt.net";
              check-url = "http://192.168.178.163:8000";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/paperless-ngx.svg";
            }
            {
              title = "Mealie";
              url = "https://mealie.wurt.net";
              check-url = "http://localhost:9000";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/mealie.svg";
            }
            {
              title = "Omni-tools";
              url = "https://omni-tools.wurt.net";
              check-url = "http://localhost:8083";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/webp/omni-tools.webp";
            }
            {
              title = "Mazanoke";
              url = "https://mazanoke.wurt.net";
              check-url = "http://localhost:3474";
              icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/mazanoke.svg";
            }
            ];
          }
          ];
        }
        {
          size = "small";
          widgets = [
          {
            type = "group";
            widgets = [
            {
              type = "reddit";
              show-thumbnails = true;
              subreddit = "homelab";
              style = "vertical-cards";
              show-flairs = true;
              limit = 5;
            }
            {
              type = "reddit";
              show-thumbnails = true;
              subreddit = "selfhosted";
              style = "vertical-cards";
              show-flairs = true;
              limit = 5;
            }
            ];
          }
          ];
        }
        ];
      }
      ];
# Theme configuration
      theme = {
        background-color = "249 22 12";
        contrast-multiplier = 1.2;
        primary-color = "217 92 83";
        positive-color = "115 54 76";
        negative-color = "347 70 65";
      };
    };
  };
}
