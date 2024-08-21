{config, pkgs, app-themes, ...}:{
	programs.kitty = {
		enable = true;
		shellIntegration.enableBashIntegration = true;

		font = {
			name = "Intel One Mono";
			size = 11;
		};

		settings = with app-themes.palettes.kitty; rec {
			# appearance (excluding colours)
			tab_bar_edge = "top";
			background_opacity = "0.1";
			background_blur = 1;

			# copy/paste behaviour
			copy_on_select = "clipboard";
			show_hyperlink_targets = "yes";
			skip_trailing_spaces = "smart";

			# other
			enable_audio_bell = "no";
			visual_bell_duration = "0.5";
			scrollback_pager = "bat";
			# dynamic_background_opacity = "yes";
			notify_on_finish = "unfocused bell";

			# colours
			background = "#${base00}";
			second_transparent_bg = background;
			foreground = "#${base07}";
			selection_background = foreground;
			selection_foreground = background;
			url_color = "#${base04}";
			cursor = "#${base07}";
			active_border_color = "#${base03}";
			inactive_border_color = "#${base01}";
			active_tab_background = background;
			active_tab_foreground = foreground;
			inactive_tab_background = "#${base01}";
			inactive_tab_foreground = "#${base04}";
			tab_bar_background = "#${base01}";
			wayland_titlebar_color = background;

			# normal
			color0 = "#${base00}";
			color1 = "#${base08}";
			color2 = "#${base0B}";
			color3 = "#${base0A}";
			color4 = "#${base0D}";
			color5 = "#${base0E}";
			color6 = "#${base0C}";
			color7 = "#${base07}";

			# bright
			color8 = "#${base03}";
			color9 = "#${base09}";
			color10 = "#${base01}";
			color11 = "#${base02}";
			color12 = "#${base04}";
			color13 = "#${base07}";
			color14 = "#${base0F}";
			color15 = "#${base07}";

			# extended base16 colors
			color16 = "#${base09}";
			color17 = "#${base0F}";
			color18 = "#${base01}";
			color19 = "#${base02}";
			color20 = "#${base04}";
			color21 = "#${base05}";
		};
	};
}