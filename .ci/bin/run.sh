#!/bin/bash

for LIBFILE in $(ls .ci/lib/*.sh); do
    if [ -x "${LIBFILE}" ]; then
        source "${LIBFILE}"
    fi
done

readonly BIN_ROOT='./.ci/bin'

run_script()
{
    exec bash -i -c "${@}" &
    wait ${!}

    if [ ${?} -ne 0 ]; then
        exit ${?}
    fi
}

run_script ${BIN_ROOT}/pre-build.sh
run_script ${BIN_ROOT}/build-pkgs.sh
run_script ${BIN_ROOT}/post-build.sh

