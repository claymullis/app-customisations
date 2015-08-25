{pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	apps = [
		# {
		# 	name = "Skype";
		# 	exec = "${skype}/bin/skype";
		# 	filename = "skype";
		# }
		# {
		# 	exec = "${spotify}/bin/spotify";
		# 	name = "Spotify";
		# 	filename = "spotify";
		# }
		# {
		# 	exec = "${calibre}/bin/calibre";
		# 	name = "Calibre";
		# 	filename = "calibre";
		# }

		{
			exec = "/usr/bin/env XDG_DATA_DIRS=${builtins.getEnv "HOME"}/.local/nix/share:/usr/local/share/:/usr/share/ gnome-shell";
			name = "Gnome shell";
			filename = "gnome-shell";
		}

		{
			exec = pkgs.writeScript "desktop-session" ''#!${pkgs.bash}/bin/bash
				reset-input &
				systemctl --user start desktop-session.target &
			'';
			name = "My desktop session";
			filename = "desktop-session";
		}
	];
in
stdenv.mkDerivation {
	name = "desktop-files";
	unpackPhase = "true";
	buildPhase = "true";
	installPhase = with lib; ''
		mkdir "$out"
		cd "$out"
		${
			concatStringsSep "\n" (map ({name, exec, filename ? null}:
				''
				cat > "${if filename == null then name else filename}.desktop" <<"EOF"
[Desktop Entry]
Version=1.0
Name=${name}
GenericName=${name}
Exec=${exec}
Terminal=false
Type=Application
Icon=${name}
EOF
				''
			) apps)
		}
	'';
}
