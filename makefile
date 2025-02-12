.PHONY: brew
brew:
	# Xcode command line tools
	bash -c "./xcode_cli_tools.sh"
	# Install homebrew
	bash -c "./brew_install.sh"
	# Install applications
	bash -c "./applications.sh"
	# Install terminal tools
	bash -c "./spaceship_install.sh"
	# Install Mac App Store applications
	bash -c "./mas_install.sh"
	# Install dotfiles
	bash -c "./dot_files.sh"
	# Sync Nvim Config
	bash -c "./sync_nvim_config.sh from"
