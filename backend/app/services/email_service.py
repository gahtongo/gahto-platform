import html
import logging

import resend

from app.core.config import settings
from app.models.contact_message import ContactMessage
from app.models.report import Report

logger = logging.getLogger(__name__)


class EmailDeliveryError(RuntimeError):
    """Raised when an application notification was not accepted by Resend."""


def _recipients(raw: str) -> list[str]:
    return [address.strip() for address in raw.split(",") if address.strip()]


def _send(*, subject: str, html_content: str, recipients: list[str], notification_type: str) -> str:
    if not settings.RESEND_API_KEY.strip():
        raise EmailDeliveryError("Resend is not configured")
    if not settings.EMAIL_FROM.strip():
        raise EmailDeliveryError("EMAIL_FROM is not configured")
    if not recipients:
        raise EmailDeliveryError(f"No recipients configured for {notification_type}")

    resend.api_key = settings.RESEND_API_KEY
    try:
        response = resend.Emails.send({
            "from": f"{settings.SMTP_FROM_NAME} <{settings.EMAIL_FROM}>",
            "to": recipients,
            "subject": subject,
            "html": html_content,
        })
    except Exception as exc:
        logger.exception("Email provider rejected %s notification", notification_type)
        raise EmailDeliveryError("Email provider rejected the notification") from exc

    provider_id = response.get("id") if isinstance(response, dict) else getattr(response, "id", None)
    if not provider_id:
        logger.error("Email provider returned no id for %s notification", notification_type)
        raise EmailDeliveryError("Email provider did not confirm the notification")
    logger.info("Email notification accepted type=%s provider_id=%s", notification_type, provider_id)
    return str(provider_id)


def send_admin_report_notification(report: Report) -> str:
    html_content = f"""
    <div style="font-family: sans-serif; max-width: 600px; margin: auto;">
      <h2>New incident report submitted</h2>
      <p><strong>Case type:</strong> {html.escape(report.case_type)}</p>
      <p><strong>Urgency:</strong> {html.escape(report.urgency)}</p>
      <p>Sensitive report content is available only in the protected admin panel.</p>
      <p><a href="{html.escape(settings.FRONTEND_URL)}/admin/reports">Review report</a></p>
    </div>
    """
    return _send(
        subject=f"Incident report: {report.urgency} {report.case_type}",
        html_content=html_content,
        recipients=_recipients(settings.ADMIN_NOTIFICATION_EMAILS),
        notification_type="incident_report",
    )


def send_contact_notification(message: ContactMessage) -> str:
    html_content = f"""
    <div style="font-family: sans-serif; max-width: 600px; margin: auto;">
      <h2>New contact message</h2>
      <p><strong>From:</strong> {html.escape(message.name)} &lt;{html.escape(message.email)}&gt;</p>
      <p style="white-space: pre-wrap">{html.escape(message.message)}</p>
      <p><a href="{html.escape(settings.FRONTEND_URL)}/admin/messages">Review in the admin panel</a></p>
    </div>
    """
    return _send(
        subject="New GAHTO contact message",
        html_content=html_content,
        recipients=_recipients(settings.CONTACT_NOTIFICATION_RECIPIENTS),
        notification_type="contact_message",
    )
