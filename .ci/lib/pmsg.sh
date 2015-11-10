# Default verbose level
VERBOSE=${VERBOSE:-2}

pmsg()
{
    local msg_type="${1}"
    local msg_text="${2}"

    if [ ! -z "${msg_type}" -a ! -z "${msg_text}" ]; then
        case "${msg_type}" in
            'i') [[ ${VERBOSE} -ge 2 ]] && echo -e "[${COLGRN}i${COLNON}] ${msg_text}"      ;;
            'w') [[ ${VERBOSE} -ge 1 ]] && echo -e "[${COLYLW}w${COLNON}] ${msg_text}" 1>&2 ;;
            'e') [[ ${VERBOSE} -ge 1 ]] && echo -e "[${COLRED}e${COLNON}] ${msg_text}" 1>&2 ;;
              *) pmsg 'e' 'pmsg(): incorrect usage!' ;;
        esac   
    fi

	unset msg_type msg_text
}
