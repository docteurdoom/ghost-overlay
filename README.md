# ghost-overlay
### Gentoo overlay for Ghost Coin

Prerequisites:
	
	sudo emerge --ask --noreplace app-eselect/eselect-repository dev-vcs/git

To add ghost-overlay repository:

	sudo eselect repository add ghost-overlay git https://github.com/docteurdoom/ghost-overlay
	sudo emerge --sync ghost-overlay

Now any package from [net-p2p](net-p2p) could be emerged.
