#!/bin/bash

#set -e

for LIBFILE in $(ls .ci/lib/*.sh); do
    if [ -x "${LIBFILE}" ]; then
        source "${LIBFILE}"
    fi
done

TMPDIR=${TMPDIR:-'.ci/tmp'}
SRC_LST="${TMPDIR}/sources.txt"
BUILD_ARCH=$(uname -m)

SB_PATH=${1}
SB_DIR=$(dirname ${SB_PATH})
SB_INFO="$(basename ${SB_PATH} .SlackBuild).info"

DWN_QUEUE=()
MD5_SUMS=()
OUT_FILES=()
TMP_SRC_FILES=''

prepare_queue()
{
    # Check availability of information file
    if [ ! -r "${SB_INFO}" ]; then
        pmsg 'e' "-> Missing ${SB_INFO}!"
        pmsg 'e' "-> Can't download sources!"
        exit 1
    fi

    source ${SB_INFO}

    if [ "${BUILD_ARCH}" == 'x86_64' ]; then
        # Use default sources if no arch-dependent
        # sources specified
        if [ -z "${DOWNLOAD_x86_64}" ]; then
            DWN_QUEUE=(${DOWNLOAD})
            MD5_SUMS=(${MD5SUM})
            OUT_FILES=(${OUTFILE})
        else
            DWN_QUEUE=(${DOWNLOAD_x86_64})
            MD5_SUMS=(${MD5SUM_x86_64})
            OUT_FILES=(${OUTFILE_x86_64})
        fi
    fi
}

download_file()
{
    local dwn_url=${1}
    local out_file=${2}

    pmsg 'i' "-> Downloading source file ${out_file}..."
    wget -c "${dwn_url}" -O "${out_file}"
    ret=${?}

    unset dwn_url out_file

    return ${ret}
}


proc_queue()
{
    local entries=${#DWN_QUEUE[*]}
    local i=0
    local dwn_url=''
    local md5_sum=''
    local out_file=''

    while [ ${i} -lt ${entries} ]; do
        dwn_url=${DWN_QUEUE[${i}]}
        out_file=${OUT_FILES[${i}]}
        md5_sum=${MD5_SUMS[${i}]}

        # Use output file name from URL
        # if not specified in info file
        if [ -z "${out_file}" ]; then
            out_file=$(basename ${dwn_url})
        fi

        # Download file add to downloaded files list
        download_file "${dwn_url}" "${out_file}"
        if [ ${?} -ne 0 ]; then
            pmsg 'e' '--> Failed to download source...'
            exit 1
        else
            TMP_SRC_FILES="${TMP_SRC_FILES} ${SB_DIR}/${out_file}"

            # Write md5 sum into CHECKSUMS.md5
            if [ ! -z "${md5_sum}" ]; then
                echo "${md5_sum}  ${out_file}" \
                  >> CHECKSUMS.md5
            else
                pmsg 'w' "--> Missing md5 sum for ${out_file}"
            fi
        fi

        ((i++))
        dwn_url=''
        md5_sum=''
        out_file=''
    done

    TMP_SRC_FILES="${TMP_SRC_FILES} ${SB_DIR}/CHECKSUMS.md5"

    unset entries i dwn_url md5_sum out_file
}

check_md5()
{
    md5sum -c CHECKSUMS.md5
}

pushd ${SB_DIR} 1> /dev/null
    prepare_queue
    proc_queue
    check_md5
popd

# Write sources file
pmsg 'i' 'Writing list of temporary sources list...'
echo ${TMP_SRC_FILES} \
| tr ' ' '\n' \
| tee -a ${SRC_LST}

exit 0

