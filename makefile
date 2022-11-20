.PHONY: brew
brew:
	# Install homebrew
	bash -c "./brew_install.sh"
	# Install applications
	bash -c "./applications.sh"
	# Install terminal tools
	bash -c "./space_ship_install.sh"
