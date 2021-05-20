import os
from pathlib import Path
import subprocess
import sys
import zipfile

import requests
from github import Github


def subprocess_run(args):
    print(f"    {' '.join(args)}")
    print()
    response = subprocess.run(args)
    if response.returncode != 0:
        sys.exit(response.returncode)


# Get URL of archive of git repo using API.
github = Github(os.environ["GITHUB_TOKEN"])
repo = github.get_repo(os.environ["GITHUB_REPOSITORY"])
archive_url = repo.get_archive_link("zipball", os.environ["GITHUB_REF"])

# Download and unzip archive.
rsp = requests.get(archive_url, stream=True)
if not rsp.ok or "content-disposition" not in rsp.headers:
    print(rsp)
    sys.exit(f"Could not download {archive_url}")

filename = rsp.headers["content-disposition"].split("filename=")[1]

with open(filename, "wb") as f:
    for chunk in rsp.iter_content(32 * 1024):
        f.write(chunk)

with zipfile.ZipFile(filename) as f:
    f.extractall()

    # The zipfile should contain a single directory.
    dirname = f.namelist()[0]
    assert all(name.startswith(dirname) for name in f.namelist())

os.chdir(dirname)

print(">>> Checking codelists")
if Path("codelists").exists():
    subprocess_run(["opensafely", "codelists", "check"])
else:
    print("    No codelists directory - skipping codelists tests")

print("\n\n>>> Running the project")
subprocess_run(["opensafely", "run", "run_all", "--continue-on-error", "--timestamps"])
