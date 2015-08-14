{pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	vim_configurable = if stdenv.isDarwin
		then vimUtils.makeCustomizable macvim
		else pkgs.vim_configurable;
	knownPlugins = vimPlugins // (pkgs.callPackage ./plugins.nix {});
	vim = vim_configurable.customize {
		name = "vim"; # actual binary name
		vimrcConfig.customRC = ''
			set nocompatible
			source ${src}/vimrc
		'';
		vimrcConfig.vam = {
			inherit knownPlugins;
			pluginDictionaries = [
				# load always
				{
					names = [
						"ack.vim"
						"ctrlp"
						"command-t"
						"fish-syntax"
						"fugitive"
						"indent-finder"
						"ir-black"
						"misc"
						"repeat"
						"Solarized"
						# "snipmate" # ???
						"surround"
						"Tagbar"
						"tcomment"
						"The_NERD_tree"
						"vim-nix"
						"vim-rust"
						"vim-stratifiedjs"
						"vim-visual-star-search"
					]
					++ (if knownPlugins.gsel == null then [] else ["gsel"]);
				}
				# full documentation at
				# github.com/MarcWeber/vim-addon-manager
			];
		};
	};
	src = ../../vim;
in
stdenv.mkDerivation {
	name = "vim-custom";
	buildInputs = [ makeWrapper ];
	unpackPhase = "true";
	installPhase = ''
		mkdir -p $out/bin
		makeWrapper ${vim}/bin/vim $out/bin/vim \
			--prefix PATH : ${silver-searcher}/bin \
			--prefix PATH : ${ctags}/bin \
		;
		echo -e "#!${bash}/bin/bash\nexec \"$out/bin/vim\" -g \"\$@\"" > $out/bin/gvim
		chmod +x $out/bin/*
	'';
}