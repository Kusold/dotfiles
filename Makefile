OS:=$(shell uname -s)
GPG_RECIPIENT:=0xB989072E874C4B23

all: update link install link-git-config
remote: update link user-install link-git-config
install: system-install user-install
user-install: install-vim-plugins install-tmux-plugins install-npm-packages install-weechat-ca
system-install: install-packages install-fonts
link: link-dotfiles link-bin link-secrets
update: update-submodules

help list:
	@make -rpn | sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/p ; }' | sort | egrep --color '^[^ ]*:'

link-bin:
	@mkdir -p $HOME/bin
	@ln -sf `pwd`/bin/ack-2.14-single-file $(HOME)/bin/ack
	@ln -sf `pwd`/bin/auth0-mongo $(HOME)/bin/auth0-mongo
	@ln -sf `pwd`/bin/focus $(HOME)/bin/focus
	@ln -sf `pwd`/bin/tmx $(HOME)/bin/tmx

link-dotfiles:
	@echo "### linking dotfiles ###"
	@ln -sf `pwd`/ackrc $(HOME)/.ackrc
	@ln -sf `pwd`/ansiweatherrc $(HOME)/.ansiweatherrc
	@ln -sf `pwd`/editorconfig $(HOME)/.editorconfig
	@ln -sf `pwd`/lessrc $(HOME)/.lessrc
	@ln -sf `pwd`/npmrc $(HOME)/.npmrc
	@ln -sf `pwd`/spacemacs $(HOME)/.spacemacs
	@ln -sf `pwd`/torrc $(HOME)/.torrc
	@ln -sfn `pwd`/weechat $(HOME)/.weechat
	@ln -sf `pwd`/tern-config $(HOME)/.tern-config

# fonts
	@mkdir -p $(HOME)/.config/fontconfig/
	@ln -sfn `pwd`/fonts/fonts.conf.d $(HOME)/.config/fontconfig/conf.d
	@ln -sfn `pwd`/fonts/fonts $(HOME)/.fonts

# gpg
	@mkdir -p $(HOME)/.gnupg
	@ln -sf `pwd`/gpg/gpg.conf $(HOME)/.gnupg/gpg.conf
	@ln -sf `pwd`/gpg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf

# ruby
	@ln -sf `pwd`/ruby/gemrc $(HOME)/.gemrc
	@ln -sf `pwd`/ruby/irbrc $(HOME)/.irbrc
	@ln -sf `pwd`/ruby/railsrc $(HOME)/.railsrc
# ssh
	@mkdir -p $(HOME)/.ssh
	@ln -sf `pwd`/ssh_rc $(HOME)/.ssh/rc
	@ln -sf `pwd`/xinitrc $(HOME)/.ssh/.xinitrc
# tmux
	@ln -sf `pwd`/tmux.conf $(HOME)/.tmux.conf
	@ln -sfn `pwd`/tmux $(HOME)/.tmux
# vim
	@ln -sf `pwd`/vimrc $(HOME)/.vimrc
	@ln -sfn `pwd`/vim $(HOME)/.vim

	@mkdir -p $(HOME)/.config/nvim
	@ln -sfn `pwd`/vimrc $(HOME)/.config/nvim/init.vim
	@ln -sfn `pwd`/vim/ftplugin/ $(HOME)/.config/nvim/ftplugin
# zsh
	@ln -sfn `pwd`/zplug $(HOME)/.zplug
	@ln -sf `pwd`/zsh/zlogin $(HOME)/.zlogin
	@ln -sf `pwd`/zsh/zlogout $(HOME)/.zlogout
	@ln -sf `pwd`/zsh/zprofile $(HOME)/.zprofile
	@ln -sf `pwd`/zsh/zshenv $(HOME)/.zshenv
	@ln -sf `pwd`/zsh/zshrc $(HOME)/.zshrc

	@echo "### linking dotfiles finished ###"

# This is done seperately so that it doesn't interfere with other operations
link-git-config:
	@ln -sf `pwd`/gitconfig $(HOME)/.gitconfig
	@ln -sf `pwd`/gitignore_global $(HOME)/.gitignore_global

install-fonts: install-nerd-fonts

ifeq ($(OS),Darwin)
install-nerd-fonts:
	@cd ~/Library/Fonts && curl --silent -fLo "Sauce Code Pro Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
else
install-nerd-fonts:
	@mkdir -p ~/.local/share/fonts
	@cd ~/.local/share/fonts && curl --silent -fLo "Sauce Code Pro Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
endif

ifeq ($(OS),Darwin)
install-packages: install-packages-macos
else
install-packages: install-packages-debian
endif

install-packages-macos: homebrew-upgrade homebrew-install-cli
	@echo "### You may also want to run `make homebrew-install-gui` for addional packages ###"

homebrew-upgrade:
	@echo "### upgrading homebrew ###"
	@brew update
	@brew upgrade

homebrew-install-cli:
	@echo "### installing hombrew cli packages ###"
	@brew install \
			bzr \
			chromedriver \
			cmake \
			ctags \
			dos2unix \
			fd \
			go \
			gpg2 \
			jq \
			mercurial \
			node \
			nodenv \
			rbenv \
			readline \
			reattach-to-user-namespace \
			ripgrep \
			ruby-build \
			ssh-copy-id \
			terminal-notifier \
			the_silver_searcher \
			tmux \
			vim --with-lua \
			watchman \
			yubikey-personalization \
			zsh

homebrew-install-gui:
	@echo "### installing hombrew gui packages ###"
	@brew tap \
			caskroom/fonts
	@brew cask install \
			1password \
			alfred \
			disk-inventory-x \
			docker \
			dropbox \
			filezilla \
			flux \
			font-source-code-pro \
			freemind \
			gimp \
			google-chrome \
			intellij-idea \
			java \
			little-snitch \
			private-internet-access \
			slack \
			spotify \
			steam \
			tiddlywiki \
			tunnelblick \
			veracrypt \
			visual-studio-code \
			vlc
	@echo "### installing MacOS packages finished ###"

install-packages-debian:
	@echo "TODO: install-packages-debian"
	echo $(OS)

install-vim-plugins:
	@echo "### installing vim plugins ###"
	@vim +PlugInstall +qall
	@echo "### installing vim plugins finished ###"

install-tmux-plugins:
	@echo "### installing tmux plugins ###"
	@${HOME}/.tmux/plugins/tpm/bin/install_plugins
	@echo "### installing tmux plugins finished ###"

install-npm-packages:
	@echo "### installing npm plugins ###"
	@npm install -g \
			eslint@latest \
			eslint-plugin-react@latest \
			babel-eslint@latest \
			jshint@latest \
			jshint-jsx@latest \
			clone-org-repos@latest \
			foreman@latest
	@echo "### installing npm plugins finished ###"

install-weechat-ca:
	@echo "### installing weechat ca ###"
	@${HOME}/.weechat/fetch-ca.sh
	@echo "### installing weechat ca finished ###"

update-submodules:
	@echo "### updating submodules ###"
	@git submodule update --init --recursive
	@echo "### updating submodules finished ###"

link-secrets:
	@ln -sf `pwd`/secrets/decrypted/private-env $(HOME)/.private-env

secrets-encrypt:
	@for file in $(shell find $(CURDIR)/secrets/decrypted -type f -not -name ".gitkeep" -not -name "*.swp"); do \
		f=$$(basename $$file); \
		gpg --encrypt --recipient $(GPG_RECIPIENT) --output secrets/encrypted/$$f.gpg $$file; \
	done

secrets-decrypt:
	@mkdir -p secrets/decrypted
	@for file in $(shell find $(CURDIR)/secrets/encrypted -type f -not -name ".gitkeep" -not -name "*.swp"); do \
		f=$$(basename $$file .gpg); \
		gpg2 --decrypt --output secrets/decrypted/$$f $$file; \
	done
