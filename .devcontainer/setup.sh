#!/bin/bash

set -ex

BASE_DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.. )"
SALT_REPO="https://github.com/afischer-opentext-com/salt.git"

python3 -m pip install --user --no-cache-dir --requirement "${BASE_DIR}/.devcontainer/requirements.txt"

# Checkout
if [ ! -d "${BASE_DIR}/salt" ]; then
  cd "${BASE_DIR}"
  git clone --verbose "${SALT_REPO}" --depth 1
  cd "${BASE_DIR}/salt"
  (git fetch --unshallow --verbose && git fetch --tags --verbose --prune --force) &
fi

# Install dependencies
cd "${BASE_DIR}/salt"
python3 -m pip install --user --no-cache-dir --upgrade pip
python3 -m pip install --user --no-cache-dir psutil
python3 -m pip install --user --no-cache-dir --requirement ./requirements/base.txt
python3 -m pip install --user --no-cache-dir --requirement ./requirements/crypto.txt
python3 -m pip install --user --no-cache-dir --requirement ./requirements/pytest.txt
python3 -m pip install --user --no-cache-dir --requirement ./requirements/tests.txt
python3 -m pip install --user --no-cache-dir --requirement ./requirements/pytest.txt
python3 -m pip install --user --no-cache-dir --requirement ./requirements/zeromq.txt
python3 -m pip install --user --no-cache-dir --upgrade --editable .

# Configure
ulimit -n 4095
git config --local commit.gpgsign true

mkdir --parents "/root/.local/etc/salt"
cp "${BASE_DIR}/salt/conf/master" /root/.local/etc/salt/master
grep -qxF 'root_dir: /root/.local' /root/.local/etc/salt/master || echo "root_dir: /root/.local" >> /root/.local/etc/salt/master

cp "${BASE_DIR}/salt/conf/minion" /root/.local/etc/salt/minion
grep -qxF 'root_dir: /root/.local' /root/.local/etc/salt/minion || echo "root_dir: /root/.local" >> /root/.local/etc/salt/minion
grep -qxF 'master: localhost' /root/.local/etc/salt/minion || echo "master: localhost" >> /root/.local/etc/salt/minion
grep -qxF 'id: salt-development' /root/.local/etc/salt/minion || echo "id: salt-development" >> /root/.local/etc/salt/minion
