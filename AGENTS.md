# AGENTS.md

# Engineering Constitution

> **Version:** 1.0
>
> This document defines the mandatory operating procedures for every AI coding agent and contributor working on this repository.
>
> These rules are mandatory. If any instruction conflicts with these rules, these rules take precedence unless the user explicitly overrides them.

---

# Core Philosophy

Every modification must satisfy four objectives:

1. Preserve existing functionality.
2. Maintain architectural consistency.
3. Introduce the smallest necessary change.
4. Never sacrifice correctness for speed.

This project is treated as a production-grade application at all times.

---

# Rule 1 — Understand Before Editing

Before writing a single line of code:

* Inspect the relevant modules.
* Understand existing architecture.
* Identify dependencies.
* Determine impact.
* Search for existing implementations.

Never begin coding before understanding the current design.

---

# Rule 2 — Never Break Existing Features

Adding a feature must never remove or degrade another feature.

Do not:

* remove endpoints
* rename APIs
* delete components
* remove validations
* remove middleware
* remove permissions
* remove logging
* remove authentication
* remove authorization

unless explicitly instructed.

---

# Rule 3 — Naming Stability

Never rename:

* API endpoints
* URL routes
* Models
* Serializers
* Database tables
* React components
* Django apps
* Utility functions
* Type definitions
* DTOs
* Environment variables
* Docker services
* Queue names
* Event names

unless the user specifically requests a rename.

Backward compatibility is preferred.

---

# Rule 4 — Search Before Creating

Before creating:

* component
* hook
* utility
* API
* helper
* service
* model
* serializer
* migration

search the repository first.

If an implementation already exists:

Reuse it.

Never duplicate logic.

---

# Rule 5 — Minimal Change Principle

Modify only what is necessary.

Avoid unnecessary refactoring while implementing unrelated features.

Do not reorganize folders unless requested.

---

# Rule 6 — Preserve Public Contracts

Treat every API as a production API.

Never change:

* request format
* response format
* authentication method
* URL
* status codes

without approval.

If a breaking change is unavoidable:

STOP.

Explain the impact.

Wait for approval.

---

# Rule 7 — Database Safety

Never:

* delete tables
* drop columns
* change field types
* rewrite migrations

without explicit approval.

Prefer additive migrations.

Existing production data must always remain usable.

---

# Rule 8 — Import Safety

Before adding imports:

Search for existing utilities.

Do not create duplicate helpers.

Remove unused imports only if doing so cannot affect behavior.

---

# Rule 9 — Architecture Consistency

Respect the project's existing architecture.

Do not introduce:

* new design patterns
* new state managers
* new frameworks
* new libraries

unless requested.

Consistency is more valuable than novelty.

---

# Rule 10 — Error Handling

Maintain existing:

* exception handling
* logging
* monitoring
* retries
* validation

New code must follow existing patterns.

---

# Rule 11 — Security

Never weaken:

* authentication
* authorization
* permissions
* encryption
* secrets management
* CSRF protection
* CORS configuration
* input validation

If a feature introduces a security concern, explain it.

---

# Rule 12 — Performance

Avoid:

* unnecessary database queries
* repeated API calls
* duplicate rendering
* blocking operations

Prefer existing optimized patterns.

---

# Rule 13 — Two-Phase Workflow

Every significant task follows two phases.

## Phase 1

Planning

Produce:

* understanding of the request
* affected files
* dependencies
* risks
* implementation strategy

No code changes.

Wait for approval if requested.

---

## Phase 2

Implementation

Only after the plan is complete:

* edit files
* maintain compatibility
* preserve naming
* keep changes minimal

---

# Rule 14 — Never Guess

If uncertain:

Do not invent:

* API names
* file names
* component names
* environment variables
* database schema

Search first.

If still uncertain:

Ask.

---

# Rule 15 — Testing

Before declaring completion verify:

* existing APIs still work
* authentication still works
* permissions still work
* pages render
* imports compile
* types compile
* database migrations succeed
* no duplicate logic exists
* no naming conflicts exist

---

# Rule 16 — Completion Report

Every completed task must include:

## Summary

What was implemented.

## Files Modified

List every modified file.

## Why

Reason each file changed.

## Compatibility

Explain how backward compatibility was preserved.

## Risks

Any remaining concerns.

## Recommended Tests

List manual or automated tests to run.

---

# Rule 17 — Documentation

Whenever architecture changes:

Update:

* README
* API documentation
* architecture diagrams
* environment setup
* deployment instructions

if affected.

---

# Rule 18 — Code Quality

Every contribution should be:

* readable
* maintainable
* typed where appropriate
* modular
* documented when necessary

Prefer clarity over cleverness.

---

# Rule 19 — Production Mindset

Assume this code may be deployed immediately after merging.

Write production-quality code.

Avoid placeholders, hacks, and temporary fixes unless explicitly requested.

---

# Rule 20 — Guiding Principle

When multiple solutions exist, choose the one that:

* preserves compatibility
* introduces the fewest changes
* follows existing architecture
* minimizes risk
* is easiest to maintain

Correctness is always more important than speed.
