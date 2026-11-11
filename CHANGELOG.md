# Changelog

## v1.3.2 — Dedicated workspace pages and stable accessibility
- Replaced the header accessibility popover with a dedicated Accessibility destination.
- Added persistent top-level navigation for Overview, Smart Revision, Mistake Notebook and Accessibility.
- Split Mistake Notebook out of Revision Hub into its own page with Open/Reviewed filters.
- Kept Smart Revision focused on due and upcoming concepts, with direct concept-practice actions.
- Replaced browser `zoom` text enlargement with a scale-aware typography variable applied to font-size and font shorthand declarations.
- Reworked high contrast to apply consistent text, card, border, input and button contrast.
- Simplified reduced-motion handling and added a system reduced-motion media preference.
- Validated saved accessibility values to prevent malformed local-storage settings from causing inconsistent states.
- Added tests for separate workspace destinations and accessibility implementation.

## v1.3.1 — Learning-memory wiring repair
- Incorrect answers are saved immediately after being checked.
- A quiz-run key prevents mistake entries being double-counted when results are saved.
- Browser storage failures are surfaced in the interface.
- Focused practice rejects weakly matched concept sets instead of substituting unrelated questions.
