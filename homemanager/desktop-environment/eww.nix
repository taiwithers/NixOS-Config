{config, ...}: {
  # https://elkowar.github.io/eww/configuration.html

  # first work through https://wiki.hyprland.org/Useful-Utilities/Must-have/
  xdg.configFile."${config.xdg.configHome}/eww/eww.yuck".text = ''
    (defwindow example
           :monitor 0
           :geometry (geometry :x "0%"
                               :y "20px"
                               :width "90%"
                               :height "30px"
                               :anchor "top center")
           :stacking "fg"
           :exclusive true
           :focusable true
    (greeter :text "Hi"
             :name "Tai"))


    (defwidget greeter [?text name]
      (box :orientation "horizontal"
           :halign "center"
        text
        (button :onclick "notify-send 'Hello' 'Hello, ''${name}'"
          "Greet")))

  '';

  xdg.configFile."${config.xdg.configHome}/eww/eww.css".text = '''';
}
