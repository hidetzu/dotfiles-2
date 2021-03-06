export dotfiles=${HOME}/.dotfiles

DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitignore .vscode
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
UNAME_S    := $(shell uname -s)

.DEFAULT_GOAL := help

all:

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), ls -dl $(val);)

deploy: ## Create symlink to home directory
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	bash ${dotfiles}/etc/init/deploy

init: ## Setup environment settings
	@echo '==> Start to install app using pkg manager.'
	@echo ''
	bash ${dotfiles}/etc/init/init

update: ## Fetch changes for this repo
	git pull origin master

install: update deploy init ## Run make update, deploy, init
	@exec $$SHELL

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTPATH)

goinstall: ## Install go packages
	mkdir -p ${HOME}/{bin,src}

test:
	@echo ${dotfiles}

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'