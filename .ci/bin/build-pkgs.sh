#!/bin/bash

set -e

for LIBFILE in $(ls .ci/lib/*.sh); do
    if [ -x "${LIBFILE}" ]; then
        source "${LIBFILE}"
    fi
done

TMPDIR=${TMPDIR:-'.ci/tmp'}
BUILD_ARCH=$(uname -m)

readonly OLD_COMMIT_FILE="${TMPDIR}/commit.txt"
readonly CHNG_SLKBLDS_FILE="${TMPDIR}/slackbuilds.txt"

# phobos-NNN - i486 build server
# deimos-NNN - amd64, noarch build server
SKIP_NOARCH=${SKIP_NOARCH:-'no'}
if [[ "$(hostname)" =~ ^phobos-* ]]; then
    SKIP_NOARCH='yes'
fi

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

    exec bash -i -c "./.ci/bin/download-src.sh '${sb_path}'" &
    wait $!

    if [ ${?} -ne 0 ]; then
        exit 1
    fi

    unset sb_path
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
        exec bash -i -c "fakeroot ./${sb_file}" &
        wait ${!}
	if [ ${?} -ne 0 ]; then
	    exit ${?}
	fi
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
    if grep -qP 'ARCH=.noarch.' ${SLKBLD} \
    && [ "${SKIP_NOARCH}" == 'yes' ]; then
        pmsg 'w' "Skipping noarch SlackBuild ${COLYLW}${SLKBLD}${COLNON}..."
    else
        pmsg 'i' "Processing ${COLYLW}${SLKBLD}${COLNON}"
        download_src "${SLKBLD}"
        build_pkg "${SLKBLD}"
        echo "================"
    fi
done

exit 0

