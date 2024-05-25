{config, ...}: {
  # https://elkowar.github.io/eww/configuration.html

  # first work through https://wiki.hyprland.org/Useful-Utilities/Must-have/
  xdg.configFile."${config.xdg.configHome}/eww/eww.yuck".text = ''
    ;; Variable Definitions
    (defpoll DATETIME :interval "5s" `date + \"%A %-d %B   %-I:%-M%p\"`)
    (defpoll SPEAKERVOLUME :interval "5s" `amixer get Master | tail -n1 | awk -F ' ' '{print $5}' | tr -d '[]%'`)
    (defpoll MICVOLUME :interval "5s" `amixer get Capture | tail -n1 | awk -F ' ' '{print $5}' | tr -d '[]%'`)

    ;; Fancy version: https://github.com/adi1090x/widgets/blob/c16e32c8786d67d91d6c11b50c2e183d26054186/eww/arin/eww.yuck#L29C16-L31C30
    (defpoll BATTERYCHARGE :interval "5s" `cat /sys/class/power_supply/BAT0/capacity`)
    (defpoll BATTERYSTATUS :interval "5s" `cat /sys/class/power_supply/BAT0/status`)

    ;; Network https://github.com/adi1090x/widgets/blob/c16e32c8786d67d91d6c11b50c2e183d26054186/eww/arin/eww.yuck#L37

    (defwindow topbar-window
           :monitor 0
           :geometry (geometry :x "0%"
                               :y "0%"
                               :width "100%"
                               :height "30px"
                               :anchor "top left")
           :stacking "fg"
           :exclusive true
           :focusable false
      (topbar-widget))

    (defwindow bottombar-window
        :monitor 0
        :geometry (geometry :x "0%"
                            :y "0%"
                            :width "100%"
                            :height "50px"
                            :anchor "bottom left")
        :stacking "fg"
        :exclusive true
        :focusable false
        (bottombar-widget))

    (defwidget topbar-widget []
      (box  :orientation "horizontal"
            :halign "center"
            :valign "center"
            :space-evenly "true"
            :spacing 16
            :hexpand "false"

            (box :orientation "horizontal"
                 :halign "center"
                 DATETIME)
            (box :orientation "horizontal"
                 :halign "right"
                 :space-evenly "true"
                 BATTERYSTATUS BATTERYCHARGE)
      )
    )

    (defwidget bottombar-widget [](
      box :orientation "horizontal"
          :halign "center"
          :space-evenly "true"
          :spacing 16
          :hexpand "false"

          (button :onclick `firefox` "Firefox")


    ))
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
