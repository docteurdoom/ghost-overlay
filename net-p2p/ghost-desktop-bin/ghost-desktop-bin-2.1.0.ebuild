# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit chromium-2 desktop rpm xdg

MY_PN="${PN/-bin}"

DESCRIPTION="Sleek design wallet for Ghost Coin (binary package)."
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
SRC_URI="https://github.com/ghost-coin/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}-linux-x86_64.rpm -> ${P}.rpm"
S="${WORKDIR}"

DEPEND="
	net-p2p/ghost-core[daemon,utils]
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default

	# Renaming is done due to whitespaces breaking icon caching.
	mv "opt/Ghost Desktop/" "opt/${PN}"
	mv "opt/${PN}/Ghost Desktop" "opt/${PN}/${PN}"

	pushd "usr/share/icons/hicolor"
	for DIR in $(ls -A); do
		[ -d "${DIR}" ] && mv "${DIR}/apps/Ghost Desktop.png" "${DIR}/apps/${PN}.png"
	done
	popd

	# Upstream shipped desktop entry is replaced with ebuild's.
	rm -rf "usr/share/applications/"

	# Files in local usr/lib are only used in Fedora and causing warnings if not deleted.
	rm -rf "usr/lib"
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

PREBUILT="
	${PN}
	libEGL.so
	libffmpeg.so
	libGLESv2.so
	libVkICD_mock_icd.so
"

src_install() {
	insinto /
	doins -r usr
	doins -r opt

	local b
	for b in ${PREBUILT}; do
		fperms +x "/opt/${PN}/${b}"
	done

	cp "${FILESDIR}/${PN}.desktop" "${T}"
	domenu "${T}/${PN}.desktop"

	dosym ../../opt/${PN}/${PN} usr/bin/${PN}
}

pkg_postinst() {
	xdg_pkg_postinst
}
