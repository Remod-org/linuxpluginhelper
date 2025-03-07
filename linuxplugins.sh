#!/bin/sh
#    Linux plugin helper
#    Copyright (c) 2025 RFC1920 <desolationoutpostpve@gmail.com>
#
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of the GNU General Public License
#    as published by the Free Software Foundation; version 2
#    of the License only.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
#    Optionally you can also view the license at <http://www.gnu.org/licenses/>.

# See the README.md associated with this script
# https://github.com/Remod-org/linuxpluginhelper
# No AI was used in the creation of this script.  However, Google was used.

# VARS
PLUGIN_FOLDER=/home/remod/serverfiles/oxide/plugins/
LOCS=(~/git:2 /data:1)
NOISY=0
COMMIT=1
CRON=1
#CP='/bin/cp -a'
CP='/usr/bin/rsync -av'
DIFF='/usr/bin/diff -aurb'

# MAIN (do not edit)
ECHO=''
if [[ ${COMMIT} -eq 0 ]]; then ECHO='echo ';fi

cd ${PLUGIN_FOLDER}
for i in `ls *.cs`; do
	if [[ ${NOISY} -eq 1 ]]; then echo -e "\nLooking for $i"; fi

	for loc in ${LOCS}; do
		IFS=: read -r folder depth <<< "${loc}"
		FOUND=`find ${folder} -maxdepth ${depth} -name ${i}`
		if [[ -f ${FOUND} ]]; then
			if [[ ${NOISY} -eq 1 ]]; then echo "    Found ${i} in ${folder}";fi
			changed=`${DIFF} ${PLUGIN_FOLDER}/${i} ${FOUND}`
			if [[ ${changed} != "" ]]; then
				if [[ ${CRON} -eq 1 ]]; then echo -e "    Updated ${i}\n${changed}"; fi
				${ECHO}${CP} ${FOUND} ${PLUGIN_FOLDER}
				${ECHO}touch ${PLUGIN_FOLDER}/${i}
			else
				if [[ ${NOISY} -eq 1 ]]; then
					echo -e "    Already current..."
				fi
			fi
			break
		fi
	done
done

