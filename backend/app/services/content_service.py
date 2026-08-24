import html
import re
from html.parser import HTMLParser


class _PlainTextParser(HTMLParser):
    block_tags = {"p", "div", "br", "h1", "h2", "h3", "h4", "h5", "h6", "li", "blockquote"}

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.parts: list[str] = []
        self.ignored_depth = 0

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag.lower() in {"script", "style", "iframe", "object", "embed"}:
            self.ignored_depth += 1
            return
        if self.ignored_depth:
            return
        if tag.lower() in self.block_tags:
            self.parts.append("\n")
        if tag.lower() == "li":
            self.parts.append("- ")

    def handle_endtag(self, tag: str) -> None:
        if tag.lower() in {"script", "style", "iframe", "object", "embed"}:
            self.ignored_depth = max(0, self.ignored_depth - 1)
            return
        if self.ignored_depth:
            return
        if tag.lower() in self.block_tags:
            self.parts.append("\n")

    def handle_data(self, data: str) -> None:
        if not self.ignored_depth:
            self.parts.append(data)


def normalize_news_content(value: str) -> str:
    """Normalize HTML, escaped HTML, Markdown, or text into canonical plain text."""
    decoded = value.strip()
    for _ in range(2):
        next_value = html.unescape(decoded)
        if next_value == decoded:
            break
        decoded = next_value

    parser = _PlainTextParser()
    parser.feed(decoded)
    text = "".join(parser.parts)
    text = re.sub(r"(?m)^\s{0,3}#{1,6}\s+", "", text)
    text = re.sub(r"(?m)^\s*[-*_]{3,}\s*$", "", text)
    text = re.sub(r"\*\*([^*]+)\*\*|__([^_]+)__", lambda m: m.group(1) or m.group(2), text)
    text = re.sub(r"\[([^\]]+)\]\((https?://[^)]+)\)", r"\1 (\2)", text)
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r" *\n *", "\n", text)
    return re.sub(r"\n{3,}", "\n\n", text).strip()
