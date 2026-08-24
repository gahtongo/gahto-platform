from types import SimpleNamespace
from unittest.mock import patch

import pytest

from app.services.email_service import EmailDeliveryError, send_contact_notification


def _message() -> SimpleNamespace:
    return SimpleNamespace(name="A <script>", email="a@example.com", message="Hello <b>team</b>")


def test_contact_notification_requires_configuration() -> None:
    with patch("app.services.email_service.settings.RESEND_API_KEY", ""):
        with pytest.raises(EmailDeliveryError):
            send_contact_notification(_message())


def test_contact_notification_escapes_content_and_returns_provider_id() -> None:
    with (
        patch("app.services.email_service.settings.RESEND_API_KEY", "key"),
        patch("app.services.email_service.settings.EMAIL_FROM", "notifications@example.org"),
        patch("app.services.email_service.settings.CONTACT_NOTIFICATION_RECIPIENTS", "ops@example.org"),
        patch("app.services.email_service.resend.Emails.send", return_value={"id": "email_123"}) as send,
    ):
        assert send_contact_notification(_message()) == "email_123"
        payload = send.call_args.args[0]
        assert "A &lt;script&gt;" in payload["html"]
        assert "Hello &lt;b&gt;team&lt;/b&gt;" in payload["html"]


def test_contact_notification_rejects_unconfirmed_provider_response() -> None:
    with (
        patch("app.services.email_service.settings.RESEND_API_KEY", "key"),
        patch("app.services.email_service.settings.EMAIL_FROM", "notifications@example.org"),
        patch("app.services.email_service.settings.CONTACT_NOTIFICATION_RECIPIENTS", "ops@example.org"),
        patch("app.services.email_service.resend.Emails.send", return_value={}),
    ):
        with pytest.raises(EmailDeliveryError):
            send_contact_notification(_message())
