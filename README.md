# Template R Operator

The `Template R Operator` is a template repository for the creation of R operators in Tercen. An overview of steps for developing an operator are:

1. Create a new GitHub repository using this template
2. Clone the newly created repository to your development environment (we recommend using VS Code)
3. Describe your operator specifications in the README file
4. Develop the operator (with or without assistance from the Tercen Agents)
5. Initialise or update the R packages environment using `renv`.
6. Push your changes and install the operator in Tercen

Detailed information can be found in the [Tercen developer's guide](https://tercen.github.io/developers_guide/).

## Setup Checklist

After creating your operator from this template, complete the following steps:

- [ ] Update `operator.json`:
  - Change `name` and `description`
  - Update `authors` to your organization
  - Update `container` to match your repo: `ghcr.io/YOUR_ORG/YOUR_REPO:main`
  - Update `urls` similarly
  - Configure `properties` for your operator's parameters
- [ ] If using minimal base image, uncomment and configure the Dockerfile accordingly
- [ ] Run `renv::init()` locally and commit `renv.lock`
- [ ] Push your changes to trigger the CI workflow
- [ ] **Important**: Make the Docker package publicly accessible (see below)

## GitHub Container Registry Visibility

Every ghcr.io package starts **private** the first time an image is pushed, **whatever the repository's visibility**. A public repository does not make its package public: on 2026-10-07 the public repositories `pamgene/dotplot_operator`, `pamgene/combat_operator` and `pamgene/ps12image_operator` all had private packages. Repository and package visibility are set independently.

A private package cannot be pulled by Tercen/BioNavigator. The release install check or a run fails with one of:

```
reading manifest <tag> in ghcr.io/<org>/<name>: denied
unable to retrieve auth token: invalid username/password: unauthorized
```

Both are ghcr's answer to an anonymous request for a private package.

**To make the package public** (once, after the first image push):

1. If the "Public" option is not available, an org owner must first allow public packages at `https://github.com/organizations/YOUR_ORG/settings/packages` ("Package creation"). If that setting is locked, it is set by an enterprise policy.
2. Open `https://github.com/orgs/YOUR_ORG/packages/container/YOUR_PACKAGE/settings`.
3. Under "Danger Zone", click "Change visibility", select "Public" and confirm with the package name.

There is no REST endpoint to change package visibility; it is a manual step. Per GitHub, a public package cannot be made private again.

**Verify without credentials** (200 = public, 403 = private or tag missing):

```bash
PKG=YOUR_ORG/YOUR_PACKAGE
TOKEN=$(curl -s "https://ghcr.io/token?scope=repository:$PKG:pull" | python3 -c "import json,sys; print(json.load(sys.stdin)['token'])")
curl -s -o /dev/null -w '%{http_code}\n' -H "Authorization: Bearer $TOKEN" "https://ghcr.io/v2/$PKG/tags/list"
```

## Dockerfile Options

This template provides two base image options:

| Option | Base Image | Use Case |
|--------|------------|----------|
| **Full runtime** (default) | `tercen/runtime-r44:4.4.3-8` | Most dependencies included, easier setup |
| **Minimal runtime** | `tercen/runtime-r44-minimal:4.4.3-2` | Smaller image, requires adding build dependencies |

If using the minimal runtime, uncomment the relevant lines in the Dockerfile and add any system dependencies your R packages require. Common dependencies:

- `gcc g++ musl-dev make` - C/C++ compilation (most R packages)
- `gfortran` - Fortran compiler (statistical packages, linear algebra)
- `curl-dev openssl-dev` - HTTP/SSL support
- `cargo rust` - Rust toolchain (some modern R packages)
- `build-base linux-headers libxml2-dev` - Required for installing R packages from GitHub that need compilation (e.g., pamgene packages)

## Git LFS

This template includes a `.gitattributes` file with commented-out LFS tracking rules for common large file types (`.rds`, `.csv`, `.pdf`, images). If your operator requires large data files:

1. Install Git LFS: `git lfs install`
2. Uncomment the relevant lines in `.gitattributes` for file types you need to track
3. Run `git lfs track` to verify your patterns
4. Commit the updated `.gitattributes` before adding large files

---

Below is the operator README standard structure.

### Description

The `Template R operator` is a template repository for the creation of R operators in Tercen.

### Usage

Input|.
---|---
`x-axis`        | type, description
`y-axis`        | type, description
`row`           | type, description
`column`        | type, description
`colors`        | type, description
`labels`        | type, description

Settings|.
---|---
`input_var`        | parameter description

Output|.
---|---
`output_var`        | output relation
`Operator view`        | view of the Shiny application

### Details

Details on the computation.

## Required GitHub secrets (release workflow)

| Secret | Purpose |
|---|---|
| `TERCEN_TEST_OPERATOR_USERNAME` / `_PASSWORD` / `_URI` | Tercen instance used by the release install check |
| `TERCEN_GITHUB_TOKEN` | **Classic** personal access token with `repo` scope, set as an org secret. Needed so the Tercen server can download this repo's zipball during the install check (required for private repos). Fine-grained tokens (`github_pat_...`) do **not** work on the zipball endpoint; the built-in `GITHUB_TOKEN` gives a 404. |
