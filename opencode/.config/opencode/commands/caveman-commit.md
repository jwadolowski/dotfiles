---
description: Generate a terse caveman-style commit message for staged changes
---
Generate a commit message for the current staged changes.

Conventional Commits format, e.g. `feat(foo): Add firewall rule`. Subject
≤72 chars (fits a GitHub PR title), imperative, first word after the colon
capitalized. Acronyms and proper names keep canonical case (e.g. S3, AWS,
VPN, VPC, GitHub). No period on subject. Body only when the "why" isn't
obvious from the subject — explain why over what. Describe the core change only; skip
incidental edits (formatting, comment tweaks, renames, lockfile churn) unless
they are the point. Drop filler, hedging, padding.
