# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DB_VER="4.8"
inherit autotools db-use xdg-utils git-r3

DESCRIPTION="Ghost by John McAfee privacy coin."
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
EGIT_REPO_URI="https://github.com/ghost-coin/ghost-core.git"

LICENSE="MIT"
SLOT="0"

IUSE="+asm +qrcode +dbus +wallet +hardened +gui +daemon +utils bench test upnp zeromq"
REQUIRED_USE="
	wallet? (
		|| ( gui daemon )
	)
	upnp? (
		|| ( gui daemon )
	)
	zeromq? (
		|| ( gui daemon )
	)
	dbus? ( gui )
	qrcode? ( gui )
	|| ( gui daemon utils )
"

DEP_LIB="
	>dev-libs/libsecp256k1-0.1_pre20200911:=[recovery,schnorr]
"
DEP_DB="
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx]
"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libevent:=
	daemon? ( ${DEP_LIB} )
	gui? (
		${DEP_LIB}
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		)
	dbus? ( dev-qt/qtdbus:5 )
	utils? ( ${DEP_DB} )
	wallet? (
		>=dev-db/sqlite-3.7.17:=
		${DEP_DB}
		)
	qrcode? ( media-gfx/qrencode:= )
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	zeromq? ( net-libs/zeromq:= )
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-7[cxx] >=sys-devel/clang-5 )
	gui? ( dev-qt/linguist-tools:5 )
"

RESTRICT="!test? ( test )"

S="${WORKDIR}/ghost-core-${PV}"

pkg_pretend() {
	if ! use wallet && use gui; then
		ewarn "Be aware that choosing GUI without wallet"
		ewarn "will build only GUI console."
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
		$(use_enable wallet wallet)
		$(use_with wallet sqlite)
		$(use_enable zeromq zmq)
		$(use_enable hardened hardening)
		$(use_with gui gui=qt5)
		$(use_with daemon daemon)
		$(use_enable utils util)
		$(use_enable utils util-cli)
		$(use_enable utils util-tx)
		$(use_enable utils util-wallet)
		$(use_enable bench bench)
		--disable-multiprocess
		--without-multiprocess
		--without-libs
		--disable-static
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
	if use gui; then
		update_caches
	fi
	elog "To get ${PN} running on Musl-based systems,"
	elog "make sure to set LC_ALL=\"C\" environment variable."

	if use gui; then
		elog "ghost-qt to launch GUI."
	fi

	if use daemon; then
		elog "ghostd to launch daemon."
	fi

	if use utils; then
		elog "ghost-cli to launch CLI."
		elog "ghost-tx to launch transaction utility."
		elog "ghost-wallet to launch wallet utility."
	fi
}

pkg_postrm() {
	if use gui; then
		update_caches
	fi
}
