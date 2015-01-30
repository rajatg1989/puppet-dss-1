#!/bin/bash -e

SRCDIR="${1}"
SNAPDIR="${2}"
SNAPNAME="${3}"

mkdir -p "${SNAPDIR}"

if test -d "${SNAPDIR}/${SNAPNAME}"
then
        echo "Snapshot named '${SNAPNAME}' already exists in ${SNAPDIR}"
        exit 1
fi

if test -d "${SNAPDIR}/latest"
then
        cp -al "$(readlink -f ${SNAPDIR}/latest)" "${SNAPDIR}/${SNAPNAME}"
        rm "${SNAPDIR}/latest"
fi
rsync -a --delete "${SRCDIR}/" "${SNAPDIR}/${SNAPNAME}/"
ln -s "${SNAPNAME}" "${SNAPDIR}/latest"
