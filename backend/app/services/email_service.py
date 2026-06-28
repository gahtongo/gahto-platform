import resend
from app.core.config import settings
from app.models.report import Report


def send_admin_report_notification(report: Report):
    if not settings.RESEND_API_KEY:
        return

    resend.api_key = settings.RESEND_API_KEY

    to_emails = [e.strip() for e in settings.ADMIN_NOTIFICATION_EMAILS.split(",") if e.strip()]
    if not to_emails:
        return

    subject = f"🚨 {report.urgency} Report: {report.case_type}"

    html_content = f"""
    <div style="font-family: sans-serif; max-width: 600px; margin: auto; border: 1px solid #eee; padding: 20px; border-radius: 10px;">
        <h2 style="color: #dc2626;">New Urgent Report Submitted</h2>
        <p><strong>Case Type:</strong> {report.case_type}</p>
        <p><strong>Urgency:</strong> {report.urgency}</p>
        <p><strong>Reporter:</strong> {report.reporter_name or ('Anonymous' if report.is_anonymous else 'Identified')}</p>
        <p><strong>Location:</strong> {report.full_address or report.location or 'Not provided'}</p>
        <p><strong>Incident Time:</strong> {report.incident_time or 'Not provided'}</p>
        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
        <p><strong>Description:</strong></p>
        <p style="background: #f9fafb; padding: 15px; border-radius: 8px;">{report.description}</p>
        <div style="margin-top: 30px; text-align: center;">
            <a href="{settings.FRONTEND_URL}/admin/reports"
               style="background: #1e3a8a; color: white; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: bold;">
               View in Admin Panel
            </a>
        </div>
    </div>
    """

    try:
        resend.Emails.send({
            "from": f"{settings.SMTP_FROM_NAME} <notifications@resend.dev>", # Using resend default domain for now
            "to": to_emails,
            "subject": subject,
            "html": html_content,
        })
    except Exception as e:
        # Log error or handle silently to not block the main flow
        print(f"Failed to send email via Resend: {e}")
