#!/bin/bash

set -e

for LIBFILE in $(ls .ci/lib/*.sh); do
	if [ -x "${LIBFILE}" ]; then
		source "${LIBFILE}"
	fi
done

TMPDIR=${TMPDIR:-'.ci/tmp'}

readonly OLD_COMMIT_FILE="${TMPDIR}/commit.txt"
readonly CHNG_SLKBLDS_FILE="${TMPDIR}/slackbuilds.txt"

read_slckbld_changes()
{
	SLKBLDS_LIST=$(cat ${CHNG_SLKBLDS_FILE})
	if [ -z "${SLKBLDS_LIST}" ]; then
		pmsg 'e' 'Empty SlackBuilds list!'
		exit 1
	fi
}

download_src()
{
	local sb_path=${1}
	local sb_dir=$(dirname ${sb_path})
	local sb_info="$(basename ${sb_path} .SlackBuild).info"

	pushd ${sb_dir}
		# Check availability of information file
		if [ ! -r "${sb_info}" ]; then
			pmsg 'e' "Missing ${sb_info}!"
			pmsg 'e' "Can't download sources!"
			exit 1
		fi
	popd

	unset sb_path sb_dir sb_info
}

build_pkg()
{
	local sb_path=${1}

	# Check file availability
	if [ ! -f "${sb_path}" ]; then
		pmsg 'e' "Missing SlackBuild ${sb_path}!"
		exit 1
	fi

	local sb_dir=$(dirname ${sb_path})
	local sb_file=$(basename ${sb_path})

	# cd into SlackBuild's dir and run
	pushd ${sb_dir}
		pmsg 'i' "Running build script ${COLYLW}${sb_file}${COLNON}..."
		echo
		exec fakeroot bash ${sb_file}
		echo -e '\n\n\n'
	popd

	unset sb_path sb_dir sb_file
}

upd_last_commit()
{
	local cur_commit=$(git rev-parse HEAD)
	if [ ! -z "${cur_commit}" ]; then
		pmsg 'i' "Updating last commit to ${COLBLU}${cur_commit}${COLNON}."
		echo ${cur_commit} \
		   > ${OLD_COMMIT_FILE}
	fi
	unset cur_commit
}

read_slckbld_changes

for SLKBLD in ${SLKBLDS_LIST[*]}; do
	download_src "${SLKBLD}"
	build_pkg "${SLKBLD}"
done

exit 0
