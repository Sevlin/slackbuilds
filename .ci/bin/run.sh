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
readonly BIN_ROOT="${CI_ROOT}/bin"

if [ ! -d "${CI_ROOT}/tmp" ]; then
    mkdir -pv "${CI_ROOT}/tmp"
fi

run_script()
{
    exec bash "${@}" &
    wait ${!}
    return ${?}
}

run_script ${BIN_ROOT}/pre-build.sh

if [ ${?} -eq 0 ]; then
    run_script ${BIN_ROOT}/build-pkgs.sh \
        || exit ${?}

    run_script ${BIN_ROOT}/post-build.sh \
        || exit ${?}

elif [ ${?} -eq -1 ]; then
    # Skip build
    exit 0
else
    exit ${?}
fi

exit 0
