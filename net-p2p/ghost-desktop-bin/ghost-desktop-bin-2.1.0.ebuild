# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Sleek design wallet for Ghost Coin."
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
SRC_URI="https://github.com/ghost-coin/ghost-desktop/releases/download/v${PV}/ghost-desktop-${PV}-linux-amd64.deb -> ${P}.deb"
S="${WORKDIR}"

DEPEND="
	net-p2p/ghost-core[daemon]
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default
}

# Paths are absolute because package names have whitespaces.
src_install() {
	insinto /
	doins -r opt

	fperms +x "/opt/Ghost Desktop/Ghost Desktop"
	fperms +x "/opt/Ghost Desktop/libEGL.so"
	fperms +x "/opt/Ghost Desktop/libffmpeg.so"
	fperms +x "/opt/Ghost Desktop/libGLESv2.so"
	fperms +x "/opt/Ghost Desktop/libVkICD_mock_icd.so"

	dosym /opt/Ghost\ Desktop/Ghost\ Desktop /usr/bin/ghost-desktop-bin
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	ewarn "To completely remove Ghost Desktop"
	ewarn "rm -rf ~/.config/ghost-desktop"
}
