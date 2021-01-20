# OpenSAFELY Research Action

This repo provides a GitHub Action for verifying that [OpenSAFELY](https://docs.opensafely.org/) research repos can run correctly.

To run locally, build with `docker build -t resarch-action .`.

Then:

```
docker run \
  --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --env DOCKER_RO_TOKEN=[DOCKER_RO_TOKEN] \
  --env GITHUB_TOKEN=[GITHUB_TOKEN] \
  --env GITHUB_REPOSITORY=[GITHUB_REPOSITORY] \
  --env GITHUB_REF=[REF, eg refs/heads/master] \
  resarch-action:latest
```

where:

* `DOCKER_RO_TOKEN` can be found [here](https://github.com/opensafely/server-instructions/blob/master/docs/Server-side%20how-to.md#log-in-to-docker).
* `GITHUB_TOKEN` is a [GitHub PAT](https://github.com/settings/tokens)
* `GITHUB_REPOSITORY` is eg `opensafely/risk-factors-research`
* `GITHUB_REF` is the branch or tag to run against, eg `refs/heads/master`

[Read more about GitHub Actions](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action).
