# ghost-overlay
### Gentoo overlay for [Ghost Coin](https://github.com/ghost-coin)

Prerequisites:
	
	sudo emerge --ask --noreplace app-eselect/eselect-repository dev-vcs/git

To add `ghost-overlay` repository:

	sudo eselect repository add ghost-overlay git https://github.com/docteurdoom/ghost-overlay
	sudo emerge --sync ghost-overlay

Now any package from [net-p2p](net-p2p) could be emerged, e.g.

	sudo emerge --ask net-p2p/ghost-qt

To remove `ghost-overlay` repository:
	
	sudo eselect repository remove ghost-overlay

### Notes

To run Ghost Electrum:

	electrum

To get Ghost Core components running on Musl-based systems, make sure
to set `LC_ALL="C"` environment variable.
