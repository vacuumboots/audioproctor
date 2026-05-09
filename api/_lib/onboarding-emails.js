// ─── /api/_lib/onboarding-emails.js ──────────────────────────────────────────
// Email content builders for the division onboarding sequence.
// Uses the same Resend helper from ./email.js.

const DEPLOY_GUIDE_URL  = 'https://audioproctor.com/deployment-guide.pdf';
const SUPPORT_EMAIL     = 'hello@audioproctor.com';
const APP_URL           = 'https://app.audioproctor.com';
const SETUP_GUIDE_URL   = APP_URL + '/division-admin.html';

// ─── Day 0: Welcome email ────────────────────────────────────────────────
// Sent immediately after the division's first paid activation.
// Includes IT deployment guide PDF link and Division Admin setup checklist.

function buildDay0Welcome(divisionName) {
  const subject = `Welcome to AudioProctor — Your Division Plan for ${divisionName} is Active`;

  const text = `Hi there,

Welcome to AudioProctor! Your Division Plan for ${divisionName} is now active.

Here's what to do next:

1. Review the IT Deployment Guide
   Download the PDF: ${DEPLOY_GUIDE_URL}
   This guide covers Chrome Extension deployment via Group Policy, managing access codes, and best practices for your schools.

2. Division Admin Setup Checklist
   Log in at ${APP_URL}
   ● Invite your school administrators and teachers
   ● Set up school enrolment bands
   ● Review the division dashboard for usage analytics
   ● Configure assessment settings

3. Deploy the Chrome Extension
   Your teachers' students will use the AudioProctor Chrome Extension to take assessments. The guide above walks through deployment options.

Need help getting started? Reply to this email or contact us at ${SUPPORT_EMAIL}.

— The AudioProctor Team`;

  const html = `<div style="font-family: 'DM Sans', Arial, sans-serif; max-width: 600px; margin: 0 auto;">
  <h2 style="font-family: 'Playfair Display', Georgia, serif; color: #1a1a1a;">Welcome to AudioProctor</h2>
  <p>Your Division Plan for <strong>${divisionName}</strong> is now active.</p>

  <h3 style="font-family: 'Playfair Display', Georgia, serif; color: #1a1a1a;">📋 Next Steps</h3>

  <h4>1. Review the IT Deployment Guide</h4>
  <p><a href="${DEPLOY_GUIDE_URL}" style="color: #1a1a1a;">Download the Deployment Guide PDF →</a></p>
  <p style="color: #555; font-size: 0.9rem;">Covers Chrome Extension deployment via Group Policy, managing access codes, and best practices for your schools.</p>

  <h4>2. Division Admin Setup Checklist</h4>
  <p>Log in to the <a href="${APP_URL}" style="color: #1a1a1a;">Division Admin Dashboard</a> to:</p>
  <ul style="color: #333;">
    <li>Invite school administrators and teachers</li>
    <li>Set up school enrolment bands</li>
    <li>Review division-wide usage analytics</li>
    <li>Configure assessment settings</li>
  </ul>

  <h4>3. Deploy the Chrome Extension</h4>
  <p>Your teachers' students use the AudioProctor Chrome Extension to take assessments. The deployment guide above walks through Group Policy and managed deployment options.</p>

  <hr style="border: none; border-top: 1px solid #ccc; margin: 24px 0;">
  <p style="color: #555; font-size: 0.9rem;">Need help getting started? Reply to this email or contact us at <a href="mailto:${SUPPORT_EMAIL}" style="color: #1a1a1a;">${SUPPORT_EMAIL}</a>.</p>
  <p style="color: #999; font-size: 0.8rem;">— The AudioProctor Team</p>
</div>`;

  return { subject, text, html };
}

// ─── Day 3: Follow-up email ──────────────────────────────────────────────
// Sent 3 days after activation. Asks if the extension has been deployed,
// provides the deployment guide link again, and offers support.

function buildDay3Followup(divisionName) {
  const subject = `Have you deployed the AudioProctor extension in ${divisionName}?`;

  const text = `Hi there,

It's been a few days since your Division Plan for ${divisionName} was activated. Just checking in — have you had a chance to deploy the AudioProctor Chrome Extension to your schools?

If you need the guide again: ${DEPLOY_GUIDE_URL}

If you're running into any issues or have questions, reply to this email and we'll help you get set up. We're here to make sure deployment goes smoothly for your IT team.

Still planning your rollout? No problem — take your time. The guide and your dashboard are ready whenever you are.

— The AudioProctor Team`;

  const html = `<div style="font-family: 'DM Sans', Arial, sans-serif; max-width: 600px; margin: 0 auto;">
  <h2 style="font-family: 'Playfair Display', Georgia, serif; color: #1a1a1a;">Have you deployed the extension?</h2>
  <p>It's been a few days since your Division Plan for <strong>${divisionName}</strong> was activated.</p>
  <p>Have you had a chance to deploy the AudioProctor Chrome Extension to your schools?</p>

  <p style="margin: 20px 0;">
    <a href="${DEPLOY_GUIDE_URL}" style="display: inline-block; padding: 10px 20px; background: #1a1a1a; color: #fff; text-decoration: none; font-family: 'DM Sans', Arial, sans-serif;">
      Deployment Guide PDF →
    </a>
  </p>

  <p>If you're running into any issues or have questions, reply to this email and we'll help you get set up. We're here to make sure deployment goes smoothly for your IT team.</p>

  <p>Still planning your rollout? No problem — take your time. The guide and your dashboard are ready whenever you are.</p>

  <hr style="border: none; border-top: 1px solid #ccc; margin: 24px 0;">
  <p style="color: #555; font-size: 0.9rem;">Questions? Reply to this email or contact us at <a href="mailto:${SUPPORT_EMAIL}" style="color: #1a1a1a;">${SUPPORT_EMAIL}</a>.</p>
  <p style="color: #999; font-size: 0.8rem;">— The AudioProctor Team</p>
</div>`;

  return { subject, text, html };
}

module.exports = { buildDay0Welcome, buildDay3Followup };
