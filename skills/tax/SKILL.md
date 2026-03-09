---
name: tax
description: Review transaction exports for Japanese tax filing, classify deductible expense candidates, and import selected rows into MoneyForward with safe browser automation, verification, and reconciliation.
---

# Tax Workflow

Use this skill when the user asks to:

- review card, bank, wallet, or payment-service exports for `確定申告`
- decide which transactions can be treated as business expenses
- map transactions to Japanese account titles
- import selected expenses into MoneyForward
- automate MoneyForward manual entry from CSV or similar exports

## Inputs To Gather

Before doing any posting work, confirm or infer:

- source file path and target year
- accounting target, usually MoneyForward
- user-specific account-title policy
- whether browser automation is allowed
- whether browser session reuse is allowed

If the user has an explicit bookkeeping policy, follow it and note that it is a user rule rather than a default tax judgment.

## Core Principles

- Source categories are hints, not tax truth.
- Keep every posted row traceable back to the source export.
- Prefer deterministic matching on `date + merchant/remark + amount + account text`.
- Never trust a single fast verification pass if the UI is asynchronous.
- Never retry failed rows blindly.

## Classification Workflow

1. Normalize the source data.
   - Inspect encoding, headers, duplicated columns, currencies, and date range.
   - Filter to the target year.
   - Preserve source row IDs if available.

2. Build candidate sets.
   - Split rows into `clear include`, `clear exclude`, and `manual review`.
   - Use deterministic rules first: merchant, category, currency, date, memo, amount pattern.
   - Treat ambiguous rows as manual review rather than forcing a classification.

3. Confirm account mapping.
   - Default expense entry pattern for personally paid business expenses is:
     - `借方 = expense account`
     - `貸方 = 事業主借`
   - Common mappings:
     - cafe/workspace: `雑費`
     - telecom/SIM: `通信費`
     - transport: `旅費交通費`
     - lodging: do not assume; confirm the user's policy

4. Verify tax-sensitive claims.
   - For legal or tax classification questions, prefer official NTA guidance and primary documentation.
   - If the user wants a nonstandard treatment, follow their instruction for bookkeeping work but distinguish it from general tax guidance.

## MoneyForward Automation Workflow

Prefer this order:

1. Use an isolated Playwright-controlled Chrome profile.
2. Let the user sign in manually in that isolated browser.
3. Inspect the actual MoneyForward form fields and select values before bulk posting.
4. Submit one stable accounting pattern at a time.

Avoid:

- reusing encrypted browser state unless explicitly approved and necessary
- depending on the user's live Chrome profile by default
- relying on visual clicks when direct form fields can be identified safely

## Verification Workflow

After posting rows:

1. Search the journal list using merchant or remark.
2. Match on:
   - date
   - amount
   - merchant or remark
   - expected account text
3. Record the MoneyForward transaction number for each matched row.

Do not assume success from:

- form reset
- HTTP 200
- absence of an error banner

If verification is inconsistent:

- run a second search pass
- then run a count-based audit by source row
- only retry rows that remain genuinely missing

## Reconciliation And Cleanup

If retries created duplicates:

1. Determine the intended count from the source export.
2. Search the MoneyForward journal list by merchant.
3. Identify duplicates by exact row details and transaction number.
4. Delete only the surplus rows.
5. Re-audit until the MoneyForward count matches the source count.

Use transaction numbers for deletion decisions. Do not dedupe by text similarity alone.

## Outputs

When the task finishes, provide:

- filtered or normalized source file paths, if created
- imported count
- skipped count
- manual-review count
- duplicate cleanup summary, if any
- list of unresolved rows requiring user judgment

## Notes

- Keep the main skill procedural and reusable.
- Put one-off merchant heuristics or session-specific examples in reference files if this skill grows.
