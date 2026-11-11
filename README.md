# Connect-Compass
# Concept Compass v1.3.2 — Clear learning workspace

Concept Compass is a browser-local adaptive learning prototype. QuestShift generates diagnostic and focused-practice question sets; the app remembers missed concepts, schedules revisions and keeps a personal mistake notebook.

## v1.3.2 — dedicated work areas and accessibility rework

The workspace now has four separate top-level destinations in the main navigation:

- **Overview:** start a diagnostic and see your next learning step.
- **My Progress:** view performance trends and saved test history.
- **Smart Revision:** view concepts due now, upcoming review dates and start focused practice.
- **Mistake Notebook:** browse open and reviewed mistakes, read the saved answer explanation, practise the concept or mark it reviewed.
- **Accessibility:** adjust text scale, high contrast, reduced motion and clearer font in a dedicated settings page.

Revision and Mistake Notebook are separate pages rather than sections crowded into one dashboard. Accessibility is also a dedicated page rather than a popover competing with the main content.

### Accessibility behaviour
- Text size uses scale-aware CSS typography, not browser `zoom`, so cards and layout widths do not unexpectedly magnify or overflow.
- High contrast uses explicit text, border, input and button contrast rules.
- Reduced motion disables transitions and animations.
- Clearer font uses a system sans-serif font stack.
- Settings are validated when loaded and persisted in this browser.
- Keyboard users have a skip-to-content link, visible focus styles and main-content focus when switching work areas.

### Learning memory
- **Mistake Notebook:** saves incorrect answers with the question, selected answer, expected answer, explanation, concept, date and repeat-miss count. Students can filter open/reviewed mistakes and retry a concept.
- **Smart Revision:** tracks concept-level performance and schedules the next review. Missed or low-accuracy concepts return sooner; confident performance gradually extends intervals.
- Due concepts can be practised using QuestShift and postponed by one day.

### Existing capabilities retained
- Explicit question type selection: Theory questions / Numericals / Both.
- Separate Results → Videos → Solutions → Learn → Practice screens.
- QuestShift AI question generation, focused practice, Concept Rescue, YouTube metadata matching, Pole Points and recent progress.

## Local data and privacy

Progress, revision records, mistakes and accessibility choices are stored in `localStorage` in this browser. There is no account or cross-device synchronization; this information does not sync across devices. Clearing browser data can remove these records. Saved performance context may be included in QuestShift's existing question-generation request as adaptive learning context.

## Windows setup

1. Extract the ZIP to `C:\CC132`. Confirm `package.json` and `START_CONCEPT_COMPASS.cmd` are directly inside that folder.
2. Use Node.js `20.19+` or `22.12+`.
3. Copy your existing `worker\.dev.vars` into `C:\CC132\worker\.dev.vars`. Keep your Gemini key private.
4. Double-click `START_CONCEPT_COMPASS.cmd`. It installs missing dependencies, builds `dist`, starts the Worker and frontend, and opens the app.
5. Open `http://127.0.0.1:5199/` and confirm the footer says **BUILD 1.3.2**. Keep both terminal windows open.
6. The Worker listens on port `8806`.

## Tests

From PowerShell in `C:\CC132`:

```powershell
node scripts/test-accessibility-revision.mjs
node scripts/test-workspace-sections.mjs
node scripts/test-ui-navigation.mjs
node scripts/test-learning-memory.mjs
node scripts/test-learning-memory-integration.mjs
node scripts/test-concept-matching.mjs
node scripts/smoke-test.mjs
node scripts/test-concept-videos.mjs
node scripts/test-youtube-search.mjs
node scripts/test-launcher-assets.mjs
```

## Important limitations

- Revision scheduling is a transparent heuristic, not a validated prediction of memory retention.
- Marking a mistake as reviewed is a manual notebook action; it does not itself prove mastery.
- Memory is browser-local and can be lost when browser storage is cleared.
- AI-generated questions and explanations can contain errors; check answer keys when something looks inconsistent.
- Video relevance uses available metadata, not full transcript verification. YouTube may block public metadata retrieval.
- A full production build and live Gemini/YouTube network tests must be run in the deployment environment if dependencies or external access are unavailable during local development.
