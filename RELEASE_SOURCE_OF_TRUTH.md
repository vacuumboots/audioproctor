# Extension Release Source of Truth

This file provides a verifiable chain-of-custody between:
- private repo `extension/` source
- public mirror repo `vacuumboots/audioproctor-extension`
- release artifact hash
- Chrome Web Store release metadata

## Why this is cool
This gives AudioProctor a real, auditable supply-chain story:
- Anyone can verify the public source matches the private extension subtree.
- Anyone can verify the uploaded release artifact hash.
- Each store release can be tied to a specific public commit.

In plain terms: trust is no longer “because we said so” — it is cryptographically checkable.

## Verification method
1. Compute private subtree split SHA:
   `git subtree split --prefix=extension HEAD`
2. Compare with public repo `main` SHA.
3. Build artifact from the release commit with `git archive`.
4. Record SHA256 and release metadata below.

## Attestation log

| store_version | version_name | public_commit | public_tag | artifact | sha256 | cws_published_at |
|---|---|---|---|---|---|---|
| 1.0.1 | `v1.0.1` | `_(pending main merge)_` | `store-v1.0.1` | `_(pending artifact build from main)_` | `_(pending)_` | _(pending)_ |
| 1.0.0 | `v1.0.0+git.ade0de7` | `ade0de7c49335df16489eaf1a66e03dc8728272f` | `store-v1.0.0` | `extension-v1.0.0+git.ade0de7.zip` | `77c9cd543c124828d882ee64c1e9374e5c2b220b1fc196e7223e0a8fd203995c` | _(pending)_ |

## Last local proof run
- private subtree SHA: `963d551573122e31003f3dd4aa4d4bb7bbeaef20` (from `origin/dev`, pre-main-promotion)
- public main SHA: `ade0de7c49335df16489eaf1a66e03dc8728272f`
- match: `no` (expected until `dev` is promoted to `main` and sync completes)
- artifact path used for hash: `_(pending 1.0.1 main build artifact)_`
