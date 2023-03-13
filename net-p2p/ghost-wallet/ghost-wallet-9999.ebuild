# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DB_VER="4.8"
inherit autotools db-use git-r3

DESCRIPTION="Wallet utility for Ghost by John McAfee privacy coin"
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
EGIT_REPO_URI="https://github.com/ghost-coin/ghost-core.git"

LICENSE="MIT"
SLOT="0"

IUSE="+asm +hardened test"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libevent:=
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx]
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-7[cxx] >=sys-devel/clang-5 )
"

RESTRICT="!test? ( test )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local my_econf=(
		$(use_enable asm)
		$(use_enable test tests)
		$(use_enable hardened hardening)
		--enable-util-wallet
		--disable-util-cli
		--without-qrencode
		--without-qtdbus
		--disable-zmq
		--without-gui
		--disable-util-tx
		--disable-util-util
		--without-daemon
		--disable-bench
		--without-libs
		--disable-ccache
	)
	econf "${my_econf[@]}"
}

src_install() {
	default
}

pkg_postinst() {
	elog "To get ${PN} running on Musl-based systems,"
	elog "make sure to set LC_ALL=\"C\" environment variable."
}
