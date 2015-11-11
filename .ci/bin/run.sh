#!/bin/bash

BUILD_CPU_NICE=${BUILD_CPU_NICE:-19}
BUILD_IO_NICE=${BUILD_IO_NICE:-3}

renice -n ${BUILD_CPU_NICE} -p ${$}
ionice -n ${BUILD_IO_NICE} -p ${$}

for LIBFILE in $(ls .ci/lib/*.sh); do
    if [ -x "${LIBFILE}" ]; then
        source "${LIBFILE}"
    fi
done

readonly CI_ROOT='.ci'
readonly BIN_DIR="${CI_ROOT}/bin"
readonly TMP_DIR="${CI_ROOT}/tmp"
readonly LOCK_FILE="${TMP_DIR}/.lock"
readonly OLD_COMMIT_FILE="${TMP_DIR}/commit.txt"

trap "rm -f ${LOCK_FILE}" EXIT TERM

# Create tmp dir if missing
if [ ! -d "${TMP_DIR}" ]; then
    mkdir -pv "${TMP_DIR}"
fi

# Set commit id to previous if missing
if [ ! -f "${OLD_COMMIT_FILE}" ] \
|| [ -z "$(cat ${OLD_COMMIT_FILE})" ]; then
    prev_commit=$(git rev-parse HEAD~1)
	pmsg 'i' "-> Updating last commit to previous commit ${COLBLU}${prev_commit}${COLNON}."
	echo ${prev_commit} \
	   > ${OLD_COMMIT_FILE}
	unset prev_commit
fi

run_script()
{
    exec bash "${@}" &
    wait ${!}
    return ${?}
}


# Exit if another instance is running
if [ -f ${LOCK_FILE} ]; then
    pmsg 'w' "Build ${COLRED}locked${NOCOL}! Another instance is running?"
    exit 0
fi

# Create lock file
touch ${LOCK_FILE}

run_script ${BIN_DIR}/pre-build.sh

if [ ${?} -eq 0 ]; then
    run_script ${BIN_DIR}/build-pkgs.sh \
        || exit ${?}

    run_script ${BIN_DIR}/post-build.sh \
        || exit ${?}

elif [ ${?} -eq -1 ]; then
    # Skip build
    exit 0
else
    exit ${?}
fi

exit 0
