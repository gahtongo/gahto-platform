import pytest

from app.services.content_service import normalize_news_content


@pytest.mark.parametrize(
    ("source", "expected"),
    [
        ("Ordinary plain text", "Ordinary plain text"),
        ("<p>First</p><h2>Heading</h2><p>Second</p>", "First\n\nHeading\n\nSecond"),
        ("&lt;p&gt;Escaped&lt;/p&gt;", "Escaped"),
        ("## Markdown heading\n\n**Strong** text", "Markdown heading\n\nStrong text"),
        ("<p>Safe</p><script>alert('x')</script>", "Safe"),
    ],
)
def test_normalize_news_content(source: str, expected: str) -> None:
    assert normalize_news_content(source) == expected


def test_normalize_news_content_removes_executable_markup() -> None:
    result = normalize_news_content('<iframe src="x"></iframe><img src=x onerror=alert(1)>')
    assert "<" not in result
    assert "onerror" not in result
