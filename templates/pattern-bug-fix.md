Goal:
Fix <rule/feature> failing when <condition>.

Why now:
<merchant impact, or what it blocks.>

## Scope
Reproduce, isolate the cause, fix, prove the fix.
Reproduction: <steps, or UNKNOWN>
Test store: <domain, or UNKNOWN>

Out of scope: refactoring nearby code; changing the rule's intended behaviour.

## Completion criteria
A failing case that now passes, plus a test that fails without the fix.

## Evidence
Test output at the fixed revision.
A matching AND a non-matching case — a fix that passes everything proves nothing.
Prove the test catches the regression: break it deliberately, watch it fail, restore it.

## Overrides
None. (Delete this section.)
