# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit chromium-2 rpm xdg

MY_PN="${PN/-bin}"

DESCRIPTION="Sleek design wallet for Ghost Coin."
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
SRC_URI="https://github.com/ghost-coin/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}-linux-x86_64.rpm -> ${P}.rpm"
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
	mv "opt/Ghost Desktop/" "opt/${PN}"
	mv "opt/${PN}/Ghost Desktop" "opt/${PN}/${PN}"
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

PREBUILT="
	opt/${PN}/${PN}
	opt/${PN}/libEGL.so
	opt/${PN}/libffmpeg.so
	opt/${PN}/libGLESv2.so
	opt/${PN}/libVkICD_mock_icd.so
"

src_install() {
	insinto /
	doins -r opt

	local b
	for b in ${PREBUILT}; do
		fperms +x "/${b}"
	done

	dosym ../../opt/${PN}/${PN} usr/bin/${PN}
}

pkg_postinst() {
	xdg_pkg_postinst
}
