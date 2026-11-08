/* ============================================================
   Nord for Zotero 7 — library pane, collections & tab bar
   ------------------------------------------------------------
   Install:
   1. Close Zotero.
   2. Open your Zotero profile folder:
        Help → Debug Output Logging → Show Profile Directory
      (Windows: %APPDATA%\Zotero\Zotero\Profiles\xxxx.default
       macOS:   ~/Library/Application Support/Zotero/Profiles/xxxx.default
       Linux:   ~/.zotero/zotero/xxxx.default)
   3. Create a folder named "chrome" inside the profile folder.
   4. Save this file as userChrome.css inside that chrome folder.
   5. In Zotero: Settings → Advanced → Config Editor, search for
        toolkit.legacyUserProfileCustomizations.stylesheets
      and set it to true.
   6. Restart Zotero.
   7. Make sure Settings → General → Appearance is set to "Dark".
   ============================================================ */

/* ---------- 1. Nord palette ---------- */
:root {
  --nord0: #2E3440;
  --nord0-deep: #242933;
  --nord1: #3B4252;
  --nord2: #434C5E;
  --nord3: #4C566A;
  --nord4: #D8DEE9;
  --nord4-dim: #C6CDD8;
  --nord5: #E5E9F0;
  --nord6: #ECEFF4;
  --nord7: #8FBCBB;
  --nord8: #88C0D0;
  --nord9: #81A1C1;
  --nord10: #5E81AC;
  --nord11: #BF616A;
  --nord12: #D08770;
  --nord13: #EBCB8B;
  --nord14: #A3BE8C;
  --nord15: #B48EAD;
}

/* ---------- 2. Zotero 7 material variables ---------- */
@media (prefers-color-scheme: dark) {
  :root {
    /* Surfaces — tab bar and toolbar sit one step darker than the page */
    --material-background: var(--nord0) !important;
    --material-tabbar: var(--nord0-deep) !important;
    --material-toolbar: var(--nord0-deep) !important;
    --material-sidepane: var(--nord0) !important;
    --material-menu: var(--nord1) !important;
    --material-button: var(--nord1) !important;

    /* Text */
    --fill-primary: var(--nord4) !important;
    --fill-secondary: var(--nord4-dim) !important;
    --fill-tertiary: var(--nord9) !important;
    --fill-quarternary: #D8DEE933 !important;
    --fill-quinary: #D8DEE91A !important;
    --fill-senary: #D8DEE90D !important;

    /* Borders and dividers */
    --color-border: var(--nord2) !important;
    --color-border50: #434C5E80 !important;
    --color-panedivider: var(--nord2) !important;
    --color-stripe: transparent !important;

    /* Named surfaces */
    --color-background: var(--nord0) !important;
    --color-background50: #2E344080 !important;
    --color-background70: #2E3440B2 !important;
    --color-sidepane: var(--nord0) !important;
    --color-tabbar: var(--nord0-deep) !important;
    --color-toolbar: var(--nord0-deep) !important;
    --color-menu: var(--nord1) !important;
    --color-button: var(--nord1) !important;
    --color-control: var(--nord4) !important;

    /* Accents */
    --accent-blue: var(--nord8) !important;
    --accent-teal: var(--nord7) !important;
    --accent-green: var(--nord14) !important;
    --accent-yellow: var(--nord13) !important;
    --accent-red: var(--nord11) !important;
    --accent-orange: var(--nord12) !important;
    --accent-purple: var(--nord15) !important;

    /* Scrollbars */
    --color-scrollbar: var(--nord3) !important;
    --color-scrollbar-hover: var(--nord9) !important;
    --color-scrollbar-background: transparent !important;

    /* Selected-tab top line */
    --tabline-color: var(--nord8) !important;
  }
}

/* ---------- 3. Tab bar ---------- */
@media (prefers-color-scheme: dark) {
  #tab-bar-container,
  #zotero-tabs-toolbar,
  .tab-bar-inner-container {
    background: var(--nord0-deep) !important;
    border-bottom-color: var(--nord2) !important;
    color: var(--nord4) !important;
  }

  #tab-bar-container .tab {
    background: var(--nord0-deep) !important;
    color: var(--nord4-dim) !important;
    border-color: var(--nord2) !important;
    -moz-appearance: none !important;
  }

  #tab-bar-container .tab:hover {
    background: var(--nord1) !important;
    color: var(--nord4) !important;
  }

  #tab-bar-container .tab.selected {
    background: var(--nord1) !important;
    color: var(--nord6) !important;
    border-top-color: var(--tabline-color) !important;
    box-shadow: none !important;
  }

  #tab-bar-container .tab:not(.selected) {
    border-bottom-color: var(--nord2) !important;
  }

  #tab-bar-container .tab .tab-close {
    filter: invert(0.75) !important;
  }
}

/* ---------- 4. Toolbar and search ---------- */
@media (prefers-color-scheme: dark) {
  #zotero-toolbar,
  #navigator-toolbox {
    background: var(--nord0-deep) !important;
    border-bottom: 1px solid var(--nord2) !important;
    color: var(--nord4) !important;
  }

  #zotero-tb-search,
  #zotero-search-box,
  #search-box {
    background: var(--nord1) !important;
    color: var(--nord4) !important;
    border: 1px solid var(--nord2) !important;
    -moz-appearance: none !important;
  }

  #zotero-tb-search::placeholder,
  #zotero-search-box::placeholder {
    color: var(--nord9) !important;
  }
}

/* ---------- 5. Items tree (library list) ---------- */
@media (prefers-color-scheme: dark) {
  #zotero-items-tree,
  #zotero-items-tree .virtualized-table,
  #zotero-items-tree .virtualized-table-body {
    background: var(--nord0) !important;
    color: var(--nord4) !important;
  }

  /* Remove alternating banding — keep a single paper tone */
  #zotero-items-tree .virtualized-table .row,
  #zotero-items-tree .virtualized-table .row.odd,
  #zotero-items-tree .virtualized-table .row.even {
    background: var(--nord0) !important;
    color: var(--nord4) !important;
    border-bottom-color: transparent !important;
  }

  #zotero-items-tree .virtualized-table .row:hover {
    background: var(--nord1) !important;
    color: var(--nord6) !important;
  }

  #zotero-items-tree .virtualized-table .row.selected,
  #zotero-items-tree .virtualized-table .row.highlighted {
    background: var(--nord2) !important;
    color: var(--nord6) !important;
  }

  /* When the tree loses focus, keep selection readable but softer */
  #zotero-items-tree .virtualized-table:not(:focus) .row.selected,
  #zotero-items-tree .virtualized-table:not(:focus) .row.highlighted {
    background: var(--nord1) !important;
    color: var(--nord5) !important;
  }

  #zotero-items-tree .virtualized-table .row.selected .cell,
  #zotero-items-tree .virtualized-table .row.highlighted .cell {
    color: var(--nord6) !important;
  }

  /* Column headers */
  #zotero-items-tree .virtualized-table-header,
  #zotero-items-tree .virtualized-table .header {
    background: var(--nord0) !important;
    color: var(--nord4-dim) !important;
    border-bottom: 1px solid var(--nord2) !important;
  }
}

/* ---------- 6. Collections tree (left pane) ---------- */
@media (prefers-color-scheme: dark) {
  #zotero-collections-tree,
  #zotero-collections-tree .virtualized-table,
  #zotero-collections-tree .virtualized-table-body {
    background: var(--nord0) !important;
    color: var(--nord4) !important;
  }

  #zotero-collections-tree .virtualized-table .row {
    background: var(--nord0) !important;
    color: var(--nord4) !important;
  }

  #zotero-collections-tree .virtualized-table .row:hover {
    background: var(--nord1) !important;
    color: var(--nord6) !important;
  }

  #zotero-collections-tree .virtualized-table .row.selected {
    background: var(--nord2) !important;
    color: var(--nord6) !important;
  }

  #zotero-collections-tree .virtualized-table .row.selected:not(:focus) {
    background: var(--nord1) !important;
    color: var(--nord5) !important;
  }

  /* Tag selector strip below the collections tree */
  #zotero-tag-selector-container {
    background: var(--nord0) !important;
    border-top: 1px solid var(--nord2) !important;
    border-bottom: 1px solid var(--nord2) !important;
  }

  #zotero-tag-selector-container input,
  .tag-selector-list-container {
    background: var(--nord1) !important;
    color: var(--nord4) !important;
    border-color: var(--nord2) !important;
  }

  .tag-selector-item {
    background: var(--nord1) !important;
    color: var(--nord4) !important;
  }

  .tag-selector-item:hover {
    background: var(--nord2) !important;
    color: var(--nord6) !important;
  }

  .tag-selector-item.selected {
    background: var(--nord2) !important;
    color: var(--nord6) !important;
  }
}

/* ---------- 7. Item pane / right sidebar ---------- */
@media (prefers-color-scheme: dark) {
  #zotero-item-pane,
  #zotero-sidebar,
  .sidebar,
  .item-pane {
    background: var(--nord0) !important;
    color: var(--nord4) !important;
    border-left: 1px solid var(--nord2) !important;
  }

  #zotero-item-pane .section,
  #zotero-item-pane .meta-row {
    background: var(--nord0) !important;
    color: var(--nord4) !important;
  }

  #zotero-item-pane .meta-row:hover {
    background: var(--nord1) !important;
  }
}

/* ---------- 8. Menus, popups, and dialogs ---------- */
@media (prefers-color-scheme: dark) {
  menupopup,
  .menu,
  .popup,
  panel {
    background: var(--nord1) !important;
    color: var(--nord4) !important;
    border: 1px solid var(--nord2) !important;
  }

  menuitem,
  .menu-item {
    color: var(--nord4) !important;
  }

  menuitem:hover,
  .menu-item:hover,
  menuitem[_moz-menuactive="true"] {
    background: var(--nord2) !important;
    color: var(--nord6) !important;
  }

  menuseparator,
  .menu-separator {
    border-color: var(--nord2) !important;
  }
}

/* ---------- 9. Scrollbars ---------- */
@media (prefers-color-scheme: dark) {
  scrollbar {
    background: transparent !important;
  }

  scrollbar thumb {
    background: var(--nord3) !important;
    border-radius: 4px !important;
  }

  scrollbar thumb:hover {
    background: var(--nord9) !important;
  }
}
