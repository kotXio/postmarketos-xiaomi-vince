# Source patches

The public source is split by upstream target:

- [`kernel/`](kernel/README.md): Linux changes, in one cumulative order;
- [`pmaports/`](pmaports/README.md): matching kernel-package, device and data
  package changes.

Apply each numbered directory in lexical order against the base recorded in
[`SOURCES.md`](../SOURCES.md). The series represents the physically tested
configuration, not a claim that every patch is ready for upstream acceptance.
Published patch bytes are listed in [`SHA256SUMS`](SHA256SUMS).
