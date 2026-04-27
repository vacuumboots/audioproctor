# Security Policy

AudioProctor security posture prioritizes student privacy, minimal data collection, and rapid remediation of confirmed vulnerabilities.

## Supported scope
This repository includes the private web app/API and the Chrome extension source mirrored from `extension/`.

Please report security issues for:
- Authentication and authorization flaws
- Data exposure risks
- Privilege escalation paths
- Token/key leakage
- Session or playback bypass vulnerabilities
- Supply-chain or dependency concerns with practical exploit impact

## Reporting a vulnerability
Please report privately by email:
- security@audioproctor.com

If email is unavailable, open a private communication channel with the maintainer account (`vacuumboots`) and avoid filing a public issue for unpatched vulnerabilities.

Include:
- Clear reproduction steps
- Affected file(s)/endpoint(s)
- Impact statement
- Optional PoC or logs (redact secrets/student data)

## Response targets
- Initial acknowledgment: within 3 business days
- Triage and severity assessment: within 7 business days
- Remediation timeline: shared after validation

## Disclosure policy
- Please do not publicly disclose vulnerabilities until a fix is deployed or a coordinated disclosure date is agreed.
- Good-faith reports are welcome and appreciated.

## Out of scope for public reports
- Requests for feature changes without a security impact
- Theoretical issues without plausible exploit path
- Automated scan output without reproducible impact

## Data handling expectations
AudioProctor is designed to avoid student-account collection and minimize personal data exposure. Report any deviation from this expectation immediately.
