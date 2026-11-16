# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.

## v26.9.4-1 (2026-11-16)

- First release: Continuwuity v26.9.4 (`ghcr.io/continuwuity/continuwuity:v26.9.4@sha256:5f21a556290df5b6eda30c7d695288f5c4b06f9529a64e2cae040297287496c3`).
- One service built from this repo, RocksDB on a Railway volume at `/var/lib/continuwuity`.
- Registration needs a generated token; federation runs on port 443 through `.well-known`.
