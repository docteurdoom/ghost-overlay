# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit chromium-2 rpm xdg

DESCRIPTION="Sleek design wallet for Ghost Coin."
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
SRC_URI="https://github.com/ghost-coin/ghost-desktop/releases/download/v${PV}/ghost-desktop-${PV}-linux-x86_64.rpm -> ${P}.rpm"
S="${WORKDIR}"

DEPEND="
	net-p2p/ghost-core[daemon]
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# Remove language packs bloat.
	pushd "opt/Ghost Desktop/locales" || die
	chromium_remove_language_paks
	popd || die
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
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
