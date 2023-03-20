# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DB_VER="4.8"
inherit autotools db-use xdg-utils

DESCRIPTION="Qt GUI for Ghost by John McAfee privacy coin"
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
SRC_URI="https://github.com/ghost-coin/ghost-core/archive/refs/tags/v${PV}.tar.gz -> ghost-core-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm +qrcode +dbus +wallet +hardened ccache test upnp zeromq"

RDEPEND="
	dev-libs/boost:=
	>dev-libs/libsecp256k1-0.1_pre20200911:=[recovery,schnorr]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dbus? ( dev-qt/qtdbus:5 )
	dev-libs/libevent:=
	qrcode? (
		media-gfx/qrencode:=
	)
	wallet? (
		>=dev-db/sqlite-3.7.17:=
		sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx]
		)
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	zeromq? ( net-libs/zeromq:= )
	ccache? (
			dev-util/ccache
		)
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-7[cxx] >=sys-devel/clang-5 )
	dev-qt/linguist-tools:5
"

RESTRICT="!test? ( test )"

S="${WORKDIR}/ghost-core-${PV}"

pkg_pretend() {
	if use ccache; then
	ewarn "Make sure to configure Portage accordingly"
	ewarn "to be able to use ccache."
	ewarn "https://wiki.gentoo.org/wiki/Ccache"
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local my_econf=(
		$(use_enable asm)
		$(use_with dbus qtdbus)
		$(use_with qrcode qrencode)
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable test gui-tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		$(use_enable hardened hardening)
		$(use_enable ccache ccache)
		--with-gui=qt5
		--disable-util-cli
		--disable-util-tx
		--disable-util-util
		--disable-util-wallet
		--without-daemon
		--disable-bench
		--without-libs
	)
	econf "${my_econf[@]}"
}

src_install() {
	default
}

update_caches() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	update_caches
	elog "To get ${PN} running on Musl-based systems,"
	elog "make sure to set LC_ALL=\"C\" environment variable."
}

pkg_postrm() {
	update_caches
}
