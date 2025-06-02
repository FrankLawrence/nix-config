{ config, pkgs, ... }:

{
  services.glance = {
    enable = true;
    settings = {
      server = {
        port = 8080;
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
                "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                  "UCsnGwSIHyoYN0kiINAGUKxg" # Wolfgang Channel
                  "UCWQaM7SpSECp9FELz-cHzuQ" # Dreams of Code
                  "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                  "UCeeFfhMcJa1kjtfZAGskOCA" # TechLinked
                  "UC7YOGHUfC1Tb6E4pudI9STA" # Mental Outlaw
                  "UCZNhwA1B5YqiY1nLzmM0ZRg" # Christian Lempa
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
            location = "Amsterdam";
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
            url = "https://adguard.home.wurt.net/";
            username = "pinkfloyd";
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
          {
            type = "releases";
            show-source-icon = true;
            respositories = [
              "jellyfin/jellyfin"
                "glanceapp/glance"
            ];
          }
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
              url = "https://home.wurt.net";
              check-url = "http://192.168.178.69:81";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/nginx-proxy-manager.svg";
            }
            {
              title = "Jellyfin";
              url = "https://jellyfin.home.wurt.net";
              check-url = "http://192.168.178.60:8096";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyfin.svg";
            }
            {
              title = "Immich";
              url = "https://immich.home.wurt.net";
              check-url = "http://192.168.178.60:2283";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg";
            }
            # {
            #   title = "Grafana";
            #   url = "https://grafana.home.wurt.net";
            #   check-url = "http://192.168.178.69:81";
            #   icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/grafana.svg";
            # }
            {
              title = "AdGuard Home";
              url = "https://adguard.home.wurt.net";
              check-url = "http://192.168.178.27:80";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/adguard-home.svg";
            }
            {
              title = "Home Assistant";
              url = "https://homeassistant.home.wurt.net";
              check-url = "http://192.168.178.207:8123";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/home-assistant.svg";
            }
            {
              title = "Wire Guard";
              url = "https://wg.home.wurt.net";
              check-url = "http://192.168.178.224:10086";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/wireguard.svg";
            }
            {
              title = "Linkwarden";
              url = "https://linkwarden.home.wurt.net";
              check-url = "http://192.168.178.163:3000";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/linkwarden.png";
            }
            {
              title = "Vikunja";
              url = "https://vikunja.home.wurt.net";
              check-url = "http://192.168.178.180:3456";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/vikunja.png";
            }
            {
              title = "Navidrome";
              url = "https://navidrome.home.wurt.net";
              check-url = "http://192.168.178.60:4533";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/navidrome.svg";
            }
            {
              title = "Kavita";
              url = "https://kavita.home.wurt.net";
              check-url = "http://192.168.178.60:5000";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/kavita.svg";
            }
            {
              title = "Stirling PDF";
              url = "https://stirling.home.wurt.net";
              check-url = "http://192.168.178.60:8080";
              icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/stirling-pdf.svg";
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
    openFirewall = true;
  };
}

