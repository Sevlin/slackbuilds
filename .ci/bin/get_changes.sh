#!/bin/bash

set -e

for LIBFILE in $(ls ../lib/*.sh); do
	if [ -x "${LIBFILE}" ]; then
		source "${LIBFILE}"
	fi
done

TMPDIR=${TMPDIR:-'.ci/tmp'}

readonly OLD_COMMIT_FILE="${TMPDIR}/commit.txt"
readonly CHNG_SLKBLDS_FILE="${TMPDIR}/slackbuilds.txt"

if [ -r "${OLD_COMMIT_FILE}" ]; then
	OLD_COMMIT=$(cat ../tmp/commit.txt)
else
	pmsg 'e' "Can't load old commit ID!"
	exit 1
fi

CUR_COMMIT=$(git rev-parse HEAD)

pmsg 'i' "Getting list of changed SlackBuilds..."

# Get list of Added (A), Copied (C),  Modified (M), Renamed (R) SlackBuilds
# excluding Deleted (D) onece
SLKBLDS_LST=$(git diff ${OLD_COMMIT} ${CUR_COMMIT} --name-status \
	          | awk '{ if ($1 != "D" && $2 ~ /.*\.SlackBuild/ ) print $2 }')

# Write list to stdout and file if not empty
if [ ! -z "${SLKBLDS_LST}" ]; then
	echo ${SLKBLDS_LST} \
	| tr ' ' '\n' \
	| tee "${CHNG_SLKBLDS_FILE}"
else
	pmsg 'e' "No changed SlackBuilds found!"
	exit 1
fi

exit 0
