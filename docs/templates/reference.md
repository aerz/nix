<!--
docs/templates/reference.md

Template for documenting a piece of nix code: a module, an overlay, or a
package. Copy it to docs/<kind>/<name>.md and fill in each section.

Worked examples: docs/modules/mas.md, docs/overlays/mas.md.

Delete these comments when copying.
-->

# <Name in Title Case>

> Status: <active|archived> (<date>, <commit hash>, <reason or replacement>)

## Overview

<One or two lines: what this piece of code is and what it does.>

## Background

<The problem that motivated it and when. Link upstream issues when they
exist. Skip this section when the piece exists without a specific problem
behind it.>

## How it works

<The mechanism: what option or attribute it defines, what it runs, what it
depends on. Cross-link related pieces of code.>

## Usage

<The nix code block that must exist to use it, plus any version or hash to
bump. When the piece is archived, say so in prose and keep the block as the
working form.>

## References

- <relative link to the source file>
- <external links: upstream project, issue trackers>