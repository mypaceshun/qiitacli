#!/usr/bin/env bash

PYTHON=python3
TMP_VENV_DIR=tmp
DIST_DIR=dist

make build

mkdir -p cache
curl -L -o cache/assert.tar.gz https://github.com/yosugi/assert.bash/archive/v0.3.0.tar.gz
(cd cache && tar xf assert.tar.gz)
source cache/assert.bash-0.3.0/assert.bash

# package find
NUM=`ls dist/*.tar.gz | wc -l`
assert ${NUM} -eq 1 || exit 1

NUM=`ls dist/*.whl | wc -l`
assert ${NUM} -eq 1 || exit 1

# create venv
${PYTHON} -m venv ${TMP_VENV_DIR}
${TMP_VENV_DIR}/bin/python -m pip install -U setuptools wheel pip

# install
${TMP_VENV_DIR}/bin/python -m pip install ${DIST_DIR}/*.whl || exit 1


# clean
rm -rf ${TMP_VENV_DIR} cache
