import os
import subprocess
import sys
import zipfile

import requests
from github import Github


# Log in to docker (required for running opensafely commands)
subprocess.run(
    [
        "docker",
        "login",
        "ghcr.io",
        "--username",
        "docker",
        "--password",
        os.environ["DOCKER_RO_TOKEN"],
    ],
    check=True,
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
)

# Get URL of archive of git repo using API.
github = Github(os.environ["GITHUB_TOKEN"])
repo = github.get_repo(os.environ["GITHUB_REPOSITORY"])
archive_url = repo.get_archive_link("zipball", os.environ["GITHUB_REF"])

# Download and unzip archive.
rsp = requests.get(archive_url, stream=True)
filename = rsp.headers["content-disposition"].split("filename=")[1]

with open(filename, "wb") as f:
    for chunk in rsp.iter_content(32 * 1024):
        f.write(chunk)

with zipfile.ZipFile(filename) as f:
    f.extractall()

    # The zipfile should contain a single directory.
    dirname = f.namelist()[0]
    assert all(name.startswith(dirname) for name in f.namelist())


for step_name, cmd in (
    ("Checking codelists", ["opensafely", "codelists", "check"]),
    ("Running the project", ["opensafely", "run", "run_all", "--continue-on-error"]),
):
    # Run each test command in turn.  We depend on the commands producing useful output,
    # and returning non-zero if they have failed.
    print("=" * 80)
    print(f">>> {step_name}")
    print()
    rv = subprocess.run(cmd, cwd=dirname)
    if rv.returncode != 0:
        sys.exit(1)
