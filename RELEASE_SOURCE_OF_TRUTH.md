# Extension Release Source of Truth

This file provides a verifiable chain-of-custody between:
- repo `extension/` source
- public mirror repo `vacuumboots/audioproctor-extension`
- release artifact hash
- Chrome Web Store release metadata

**Status, re-verified 2026-11-14 (the day this repo went public).** The method
below is real: replaying the 1.0.1 artifact from its commit reproduces the
recorded SHA256 exactly. The log itself had drifted, and this pass says so
rather than tidying it away. Releases 1.1.0 through 1.3.1 were published to the
store with no row here. Rows for 1.4.0 and 1.4.1 were added from the commits
that carry those versions, with no store-upload hash to compare against because
the developer dashboard does not expose one. Treat those two rows as reproducible
builds of a known commit, not as a claim about bytes Google received.

## Why this is cool
This gives AudioProctor a real, auditable supply-chain story:
- Anyone can verify the public source matches the `extension/` subtree.
- Anyone can rebuild the artifact from a commit and check its hash.
- Each store release is tied to a specific commit.

In plain terms: trust is no longer "because we said so". It is checkable.

## Verification method
1. Compute the `extension/` subtree split SHA:
   `git subtree split --prefix=extension <commit>`
2. Compare with the public repo `main` SHA.
3. Build the artifact from the release commit: `git archive --format=zip --output <name>.zip <commit>`
4. Record the SHA256 and the release metadata below.

The artifact is a full-repo archive, not an `extension/`-only zip. That is the
form the 1.0.x hashes were produced in, and the 1.0.1 replay below is what
confirms it.

## Attestation log

| store_version | version_name | commit | public_tag | artifact | sha256 | cws_published_at |
|---|---|---|---|---|---|---|
| 1.4.1 | `v1.4.1` | `8521bdf23138ac2724b7ed1b8385bddf414fdf58` | _(none)_ | `extension-v1.4.1+git.8521bdf.zip` | `8fe877709f1b19985f4d38d09c9258f7a33b01f0dac444c9f5e7af2fc23be9f1` | not on the store. Listing shows v1.4.0, so this version is bumped and mirrored but unpublished |
| 1.4.0 | `v1.4.0` | `436a2e247836d2e2668fd3956e47ce54ee9fdd3b` | _(none)_ | `extension-v1.4.0+git.436a2e2.zip` | `10bdde101a4f0ef0baa670921eb12caf230675dc6bc3a8efd12ac2a7cca4d9b6` | listing: updated 2026-05-09 |
| 1.0.1 | `v1.0.1` | `963d551573122e31003f3dd4aa4d4bb7bbeaef20` | `store-v1.0.1` | `extension-v1.0.1+git.963d551.zip` | `9a2602d01e805b804205b3ce700952284762543b90402dcfea648be0db8ca2a2` | submitted for review 2026-04-27T13:58:52-06:00 |
| 1.0.0 | `v1.0.0+git.ade0de7` | `ade0de7c49335df16489eaf1a66e03dc8728272f` | `store-v1.0.0` | `extension-v1.0.0+git.ade0de7.zip` | `77c9cd543c124828d882ee64c1e9374e5c2b220b1fc196e7223e0a8fd203995c` | _(pending)_ |

Unrecorded: 1.1.0, 1.2.x, 1.3.0, 1.3.1. If a hash for any of them turns up, add
the row rather than editing this note.

The `store-v1.0.1` tag was cut retroactively on 2026-11-14 at `963d551`, so the
row above resolves.

## Last proof run
2026-11-14, from `main` at `b203f9b`:

- `extension/` subtree of HEAD: `4c2908ad445751a63752925cc9d05f46857af2c8`
- public mirror `main`: `4c2908ad445751a63752925cc9d05f46857af2c8`
- match: **yes**
- 1.0.1 replay: `git archive` at `963d551` gives
  `9a2602d01e805b804205b3ce700952284762543b90402dcfea648be0db8ca2a2`, identical
  to the recorded row. The method reproduces.
