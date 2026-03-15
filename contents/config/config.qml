// SPDX-License-Identifier: GPL-3.0-or-later
// Forked from work by zayronxio (https://store.kde.org/p/2175475/)
// Modifications Copyright (C) 2026 Catking14

import QtQuick 2.12
import org.kde.plasma.configuration 2.0

ConfigModel {
	ConfigCategory {
		name: i18n("General")
		icon: "preferences-desktop"
		source: "GeneralConfig.qml"
	}
}
