{config, ...}: {
  # https://elkowar.github.io/eww/configuration.html

  # first work through https://wiki.hyprland.org/Useful-Utilities/Must-have/
  xdg.configFile."${config.xdg.configHome}/eww/eww.yuck".text = ''
    (defwindow example
           :monitor 0
           :geometry (geometry :x "0%"
                               :y "0%"
                               :width "100%"
                               :height "30px"
                               :anchor "top center")
           :stacking "fg"
           :exclusive true
           :focusable false
      (topbar))

    (defwidget topbar []
      (box :orientation "horizontal"
           :halign "right"
           EWW_TIME)
    )
  '';
  # (greeter :text "Hi"
  #          :name "Tai"))
  # (defwidget greeter [?text name]
  #   (box :orientation "horizontal"
  #        :halign "center"
  #     text
  #     (button :onclick "dunstify 'Hello' 'Hello, ''${name}'"
  #       "Greet")))

  xdg.configFile."${config.xdg.configHome}/eww/eww.css".text = '''';
}
