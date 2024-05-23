{config, ...}: {
  xdg.configFile."${config.xdg.configHome}/eww/eww.yuck".text = ''
    (defwindow example
           :monitor 0
           :geometry (geometry :x "0%"
                               :y "20px"
                               :width "90%"
                               :height "30px"
                               :anchor "top center")
           :stacking "fg"
           :reserve (struts :distance "40px" :side "top")
           :windowtype "dock"
           :wm-ignore false
    "example content")

  '';

  xdg.configFile."${config.xdg.configHome}/eww/eww.css".text = '''';
}
