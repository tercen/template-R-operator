# =============================================================================
# BASE IMAGE OPTIONS
# =============================================================================
# Option A: Full runtime (default) - larger image, most dependencies included
FROM tercen/runtime-r44:4.4.3-8

# Option B: Minimal runtime - smaller image, faster pulls
# Uncomment the lines below and comment out Option A above to use minimal image
# FROM tercen/runtime-r44-minimal:4.4.3-2
# RUN apk update && apk add --no-cache \
#     gcc g++ musl-dev make gfortran \
#     curl-dev openssl-dev git pkgconfig
# # Uncomment if your R packages have Rust dependencies (e.g., stringi, gifski):
# #   cargo rust

COPY . /operator
WORKDIR /operator

RUN R -e "renv::consent(provided = TRUE); renv::restore(confirm = FALSE)"

ENV TERCEN_SERVICE_URI https://tercen.com

ENTRYPOINT ["R", "--no-save", "--no-restore", "--no-environ", "--slave", "-f", "main.R", "--args"]
CMD ["--taskId", "someid", "--serviceUri", "https://tercen.com", "--token", "sometoken"]
