install:
	@sh -c ../../shell/tools/delta/install.sh

conf:
	@mkdir -p ~/.config/delta
	@ln -s $(PWD)/.gitconfig ~/.config/delta/.gitconfig
	@git config --global include.path ~/.config/delta/.gitconfig
