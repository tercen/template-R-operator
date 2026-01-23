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

By default, GitHub Container Registry (ghcr.io) packages inherit the repository's visibility settings. If your repository is **private**, the Docker image will also be private, and Tercen/BioNavigator will fail to pull it with an error like:

```
Error response from daemon: denied
```

**To fix this**, you have two options:

1. **Make the package public** (recommended if repo stays private):
   - Go to `https://github.com/orgs/YOUR_ORG/packages`
   - Find your operator package
   - Click "Package settings"
   - Under "Danger Zone", click "Change visibility" and select "Public"

2. **Make the repository public**:
   - This automatically makes associated packages public

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
