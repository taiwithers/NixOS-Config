{
  pkgs,
  ...
}:
{
  programs.firefox =
    let
      extensions = pkgs.nur.repos.rycee.firefox-addons;
    in
    rec {
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable
      enable = true;
      package = pkgs.firefox.override {
        nativeMessagingHosts = [
          pkgs.kdePackages.plasma-browser-integration
          pkgs.keepassxc
        ];
      };

      policies = {
        # about:policies
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableFirefoxStudies = true;
        DisableTelemetry = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PromptForDownloadLocation = true;
        ShowHomeButton = false;
      };

      profiles."Personal" = {
        path = "Profiles/Personal";
        id = 0;

        extensions = {
          packages =
            with extensions;
            [
              bitwarden
              clearurls
              cookie-autodelete
              consent-o-matic
              darkreader
              decentraleyes
              enhancer-for-nebula
              indie-wiki-buddy
              keepassxc-browser
              lovely-forks
              privacy-badger
              reddit-enhancement-suite
              refined-github
              search-by-image
              shinigami-eyes
              snowflake # tor extension to let others use connection
              # socialfocus, companion to untrap, not available in nur
              sponsorblock
              tabliss
              ublock-origin
              untrap-for-youtube
              vimium
              wayback-machine
              xkit-rewritten
              # no-pdf-download # https://addons.mozilla.org/en-US/firefox/addon/no-pdf-download-improved/
              # https://addons.mozilla.org/en-US/firefox/addon/mute-sites-by-default/
            ];
          };

        search = rec {
          force = true;
          default = "ddg";
          privateDefault = default;
          engines = {
            "google".metaData.hidden = false;
            "Wikipedia".metaData.hidden = false;
            "bing".metaData.hidden = true;
            "ebay".metaData.hidden = true;
            "perplexity".metaData.hidden = true;
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
          };
        };

        # other things failing to bring down ram usage
        # gfx.max-alloc-size - reset
        # gfx.max-texture-size - rest
        # browser.cache.disk.max_chunks_memory_usage - reset
        # browser.cache.disk.max_entry_size - reset
        # browser.cache.disk.max_priority_chunks_memory_usage - reset
        # javascript.options.mem.max
        # webgl.max-size-per-texture-mib - reset
        # browser.tabs.unloadOnLowMemory
        # image.mem.surfacecache.max_size_kb
        # javascript.options.mem.notify
        settings = {
          "breakpad.reportURL" = ""; # betterfox
          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;
          "browser.bookmarks.openInTabClosesMenu" = false;
          "browser.cache.disk.enable" = true; # betterfox, fastofx
          "browser.cache.jsbc_compression_level" = 3; # betterfox, disk cache
          "browser.cache.memory.capacity" = 15000;
          "browser.compactmode.show" = true;
          "browser.contentblocking.category" = "strict";
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # betterfox
          "browser.discovery.enabled" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.manager.addToRecentDocs" = false;
          "browser.download.open_pdf_attachments_inline" = true;
          "browser.download.start_downloads_in_tmp_dir" = true; # betterfox security
          # "browser.download.useDownloadDir" = false; # ask where to save files, done by PromptForDownloadLocation policy
          "browser.engagement.home-button.has-removed" = true;
          "browser.formfill.enable" = false;
          "browser.helperApps.deleteTempFileOnExit" = true; # betterfox security
          "browser.menu.showViewImageInfo" = true; # betterfox
          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          # "browser.ml.linkPreview.enabled" = false; # off by default rn
          # "browser.ml.linkPreview.optin" = false; # off by default rn
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # betterfox "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # betterfox
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false; # betterfox
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = true; # betterfox
          "browser.newtabpage.activity-stream.showWeather" = false;
          "browser.newtabpage.activity-stream.telemetry" = false; # betterfox
          "browser.preferences.moreFromMozilla" = false;
          "browser.privatebrowsing.vpnpromourl" = ""; # betterfox
          "browser.profiles.enabled" = true;
          "browser.safebrowsing.downloads.remote.enabled" = false; # betterfox
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.sessionhistory.max_total_viewers" = 5; # max pages stored in memory to improve back/forward
          "browser.sessionstore.restore_pinned_tabs_on_demand" = true; # instead of always
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.page" = 3; # always restore session
          "browser.tabs.crashReporting.sendReport" = false; # betterfox
          "browser.tabs.groups.smart.enabled" = false; # ai bullshit
          # "browser.tabs.groups.smart.optin" = false; # off by default
          "browser.tabs.groups.smart.userEnabled" = false; # ai bullshit
          "browser.uitour.enabled" = false; # betterfox security
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.suggest.calculator" = true;
          "browser.urlbar.trending.featureGate" = false; # betterfox
          "browser.urlbar.trimHttps" = true;
          "browser.urlbar.unitConversion.enabled" = true;
          "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
          "browser.urlbar.update2.engineAliasRefresh" = true;
          "browser.xul.error_pages.expert_bad_cert" = true; # betterfox security
          "captivedetect.canonicalURL" = ""; # betterfox
          "content.notify.interval" = 100000; # betterfox - fastfox
          "cookiebanners.service.mode" = 1; # betterfox
          "cookiebanners.service.mode.privateBrowsing" = 1; # betterfox
          "datareporting.healthreport.uploadEnabled" = false; # betterfox
          "datareporting.policy.dataSubmissionEnabled" = false; # betterfox
          "devtools.chrome.enabled" = true; # custom css
          "devtools.debugger.remote-enabled" = true; # custom css
          "dom.security.https_first" = true; # betterfox security
          "editor.truncate_user_pastes" = false;
          "extensions.activeThemeID" = "default-theme@mozilla.org"; # follow system gtk theme
          "extensions.autoDisableScopes" = 0; # enable nix-downloaded extensions
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "extensions.pocket.enabled" = false;
          "extensions.ml.enabled" = false;
          "findbar.highlightAll" = true; # betterfox
          "full-screen-api.transition-duration.enter" = "0 0"; # betterfox
          "full-screen-api.transition-duration.leave" = "0 0"; # betterfox
          "full-screen-api.warning.timeout" = 0; # betterfox
          "gfx.canvas.accelerated.cache-items" = 4096; # betterfox - fastfox
          "gfx.canvas.accelerated.cache-size" = 512; # betterfox - fastfox
          "gfx.content.skia-font-cache-size" = 20; # betterfox - fastfox
          "image.mem.decode_bytes_at_a_time" = 32768; # betterfox - fastfox
          "layout.word_select.eat_space_to_next_word" = false; # betterfox
          "media.cache_readahead_limit" = 7200; # betterfox - fastfox
          "media.cache_resume_threshold" = 3600; # betterfox - fastfox
          "media.hardware-video-decoding.enabled" = true; # use gpu for video
          "media.memory_cache_max_size" = 65536; # betterfox - fastfox
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
          "network.auth.subresource-http-auth-allow" = 1;
          "network.captive-portal-service.enabled" = false; # betterfox
          "network.connectivity-service.enabled" = false; # betterfox
          "network.dns.disablePrefetch" = true; # betterfox - fastfox
          "network.dns.disablePrefetchFromHTTPS" = true; # betterfox - fastfox
          "network.dnsCacheExpiration" = 3600; # betterfox - fastfox
          "network.http.max-connections" = 1800; # betterfox - fastfox
          "network.http.max-persistent-connections-per-server" = 10; # betterfox - fastfox
          "network.http.max-urgent-start-excessive-connections-per-host" = 5; # betterfox - fastfox
          "network.http.pacing.requests.enabled" = false; # betterfox - fastfox
          "network.http.referer.XOriginTrimmingPolicy" = 2; # betterfox
          "network.IDN_show_punycode" = true; # betterfox security
          "network.predictor.enable-prefetch" = false; # betterfox - fastfox
          "network.predictor.enabled" = false; # betterfox - fastfox
          "network.prefetch-next" = false; # betterfox - fastfox
          "network.ssl_tokens_cache_capacity" = 10240; # betterfox - fastfox
          "pdfjs.enableScripting" = false;
          "permissions.default.geo" = 2; # betterfox, always block location requests (0 to ask every time)
          "permissions.manager.defaultsUrl" = ""; # betterfox
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.globalprivacycontrol.enabled" = true; # betterfox security
          "privacy.history.custom" = true; # betterfox security
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.ui.enabled" = true; # betterfox
          "security.insecure_connection_text.enabled" = true; # betterfox security
          "security.insecure_connection_text.pbmode.enabled" = true; # betterfox security
          "security.mixed_content.block_display_content" = true;
          "security.OCSP.enabled" = 0; # betterfox security
          "security.pki.crlite_mode" = 2; # betterfox security
          "security.remote_settings.crlite_filters.enabled" = true; # betterfox security
          "security.ssl.treat_unsafe_negotiation_as_broken" = true; # betterfox security
          "security.tls.enable_0rtt_data" = false; # betterfox security
          "signon.formlessCapture.enabled" = false;
          "signon.privateBrowsingCapture.enabled" = false;
          "toolkit.coverage.endpoint.base" = ""; # betterfox
          "toolkit.coverage.opt-out" = true; # betterfox
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # allow using userchrom & usercontent
          "toolkit.telemetry.archive.enabled" = false; # betterfox
          "toolkit.telemetry.bhrPing.enabled" = false; # betterfox
          "toolkit.telemetry.coverage.opt-out" = true; # betterfox
          "toolkit.telemetry.enabled" = false; # betterfox
          "toolkit.telemetry.firstShutdownPing.enabled" = false; # betterfox
          "toolkit.telemetry.newProfilePing.enabled" = false; # betterfox
          "toolkit.telemetry.server" = "data:,"; # betterfox
          "toolkit.telemetry.shutdownPingSender.enabled" = false; # betterfox
          "toolkit.telemetry.unified" = false; # betterfox
          "toolkit.telemetry.updatePing.enabled" = false; # betterfox
          "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com"; # betterfox security
          "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com"; # betterfox security
          "webchannel.allowObject.urlWhitelist" = ""; # betterfox
          "widget.gtk.global-menu.wayland.enabled" = true;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.settings" = 1;
          "widget.use-xdg-desktop-portal.location" = 1;
          "widget.use-xdg-desktop-portal.open-uri" = 1;
        };

        userChrome = builtins.readFile ./userChrome.css;
        userContent = builtins.readFile ./userContent.css;
      };

    };
  home.file =
    let
      prefix = ".mozilla/firefox/Profiles/";
      suffix = "chrome_debugger_profile/chrome/userContent.css";
    in
    {
      "${prefix}/Personal/${suffix}".source = ./debuggerUserContent.css;
    };

  home.packages = [ pkgs.select-browser ];

  # firefox work profile desktop icon
  xdg.desktopEntries =
    builtins.mapAttrs
      (entryname: profile: rec {
        name = "Firefox - ${entryname}";
        exec = "firefox -P ${profile} %U --name ${name} --class ${name}";
        settings.StartupWMClass = name;
        icon = ./green.png;
      })
      {
        # TA = "Staff";
        Personal = "Personal";
        Student = "Student";
      };
}
