/*
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: vgawen <gdb_1986@163.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef CONFIGURATIONDOCK_GLOBAL_H
#define CONFIGURATIONDOCK_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(CONFIGURATIONDOCK_LIBRARY)
#  define CONFIGURATIONDOCKSHARED_EXPORT Q_DECL_EXPORT
#else
#  define CONFIGURATIONDOCKSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // CONFIGURATIONDOCK_GLOBAL_H