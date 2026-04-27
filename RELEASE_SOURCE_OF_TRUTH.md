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
| 1.0.0 | _(not yet stamped in manifest; recommended: `v1.0.0+git.72d438e`)_ | `72d438e4d40780f617786933768e911d97b72bc2` | _(pending)_ | `extension-v1.0.0+git.72d438e.zip` | `339b32a6e4ea64bdf1c2c56f3d8725e7540ab2724833755f26c366808d298a72` | _(pending)_ |

## Last local proof run
- private subtree SHA: `72d438e4d40780f617786933768e911d97b72bc2`
- public main SHA: `72d438e4d40780f617786933768e911d97b72bc2`
- match: `yes`
- artifact path used for hash: `/tmp/extension-v1.0.0+git.72d438e.zip`
