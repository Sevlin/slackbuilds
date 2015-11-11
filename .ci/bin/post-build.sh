#!/bin/bash

set -e

for LIBFILE in $(ls .ci/lib/*.sh); do
    if [ -x "${LIBFILE}" ]; then
        source "${LIBFILE}"
    fi
done

TMPDIR=${TMPDIR:-'.ci/tmp'}

readonly OLD_COMMIT_FILE="${TMPDIR}/commit.txt"
readonly SRC_LST="${TMPDIR}/sources.txt"

rm_sources()
{
    pmsg 'i' '-> Removing source files...'
    for src_file in $(cat ${SRC_LST} | sort | uniq); do
        if [ -f "${src_file}" ]; then
            pmsg 'i' "--> ${COLYLW}${src_file}${COLNON}..."
            rm -f "${src_file}" > /dev/null
        fi
    done
}

upd_last_commit()
{
    local cur_commit=$(git rev-parse HEAD)
    if [ ! -z "${cur_commit}" ]; then
        pmsg 'i' "-> Updating last commit to ${COLBLU}${cur_commit}${COLNON}."
        echo ${cur_commit} \
           > ${OLD_COMMIT_FILE}
    fi
    unset cur_commit
}

pmsg 'i' 'Starting post-build routines...'
upd_last_commit
rm_sources

exit 0

