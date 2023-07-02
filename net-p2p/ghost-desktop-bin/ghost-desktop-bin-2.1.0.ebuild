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
	sys-libs/glibc
"
RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
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
