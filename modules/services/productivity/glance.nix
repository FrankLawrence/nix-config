{ config, lib, pkgs, ... }:
let
  # Build a clean site attrset, omitting null optional fields.
  mkSite = site:
    { inherit (site) title url; }
    // lib.optionalAttrs (site.check-url != null) { check-url = site.check-url; }
    // lib.optionalAttrs (site.icon     != null) { inherit (site) icon; };

  # Services running on external hosts (not managed by centauri modules).
  externalSites = [
    {
      title = "Home Assistant";
      url = "https://ha.wurt.net";
      check-url = "http://192.168.178.207:8123";
      icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/home-assistant.svg";
    }
    {
      title = "Synology NAS";
      url = "https://synology.wurt.net";
      icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/synology.svg";
    }
  ];
in
{
  # age.secrets.adguard = {
  #   file = ../../../secrets/adguard.age;
  # };

  services.glance = {
    settings = {
      server = {
        # port = 8084;
        port = 3000;
        host = "127.0.0.1";
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
              # password = config.age.secrets.adguard.path;
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
          ];
        }
        {
          size = "full";
          widgets = [
          {
            type = "monitor";
            cache = "1m";
            title = "Services";
            # Centauri-managed services register themselves via custom.glance.monitoredSites.
            # External services (other hosts) are listed below.
            sites =
              (map mkSite config.custom.glance.monitoredSites)
              ++ externalSites;
          }
          {
            type = "group";
            widgets = [
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
              {
                type = "rss";
                title = "Blogs";
                limit = 50;
                style = "detailed-list";
                collapse-after = 3;
                cache = "24h";
                feeds = [
                  { url = https://www.leftfold.tech/feed.xml; }
                  { url = https://dixken.de/feed.xml; }
                  { url = https://tratt.net/laurie/blog/blog.rss ; }
                  { url = https://www.terrygodier.com/feed.xml ; }
                  { url = https://blog.terrygodier.com/feed.xml ; } 
                  { url = https://jakelazaroff.com/rss.xml ; }
                  { url = https://ploum.net/atom_en.xml ; }
                  { url = https://excaliburheath.com/feed.xml ; }
                  { url = https://ericmigi.com/rss.xml ; }
                  { url = https://stanislas.blog/feed.xml ; }
                  { url = https://brainbaking.com/index.xml ; }
                  { url = https://jvns.ca/atom.xml ; }
                  { url = https://untested.sonnet.io/feed.xml ; }
                  { url = https://arne.me/blog/atom.xml ; }
                  { url = https://davi.sh/rss.xml ; }
                  { url = https://martinheinz.dev/rss ; }
                  { url = https://haseebmajid.dev/posts/index.xml ; }
                  { url = https://paulgraham.com/rss.html ; }
                  { url = https://maggieappleton.com/rss.xml ; }
                  { url = https://xeiaso.net/blog.rss ; }
                  { url = https://aboutfeeds.com/ ; }
                  { url = https://www.danielcorin.com/rss.xml ; }
                  { url = https://bg.raindrop.io/rss/public/48340159 ; }
                  { url = https://growingswe.com/feed.xml ; }
                  { url = https://ellanew.com/feed.rss ; }
                  { url = https://rss.beehiiv.com/feeds/1erpUYd0Eq.xml ; }
                  { url = https://www.inkandswitch.com/index.xml; }
                  { url = https://xkcd.com/rss.xml; }
                  # { url = ; } Floor796
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
            type = "group";
            widgets = [
            {
              type = "reddit";
              show-thumbnails = true;
              subreddit = "centauri";
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
