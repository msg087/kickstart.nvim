return {
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
      expandWorkspaceToModule = true,
      staticcheck = true,
      matcher = 'Fuzzy',
      gofumpt = true,

      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
        shadow = true,
        unusedvariable = true,
        unusedresult = true,
      },

      codelenses = {
        generate = true,
        gc_details = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },

      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },

      importShortcut = 'Both',
      symbolMatcher = 'FastFuzzy', -- "CaseInsensitive", "CaseSensitive", "FastFuzzy", "Fuzzy"
      -- matcher = "Fuzzy",                 -- Options: CaseInsensitive, CaseSensitive, Fuzzy
      -- experimentalPostfixCompletions = true,  -- Enable postfix snippets (e.g. `.sort!`)
      hoverKind = 'FullDocumentation', -- Options: FullDocumentation, NoDocumentation, SingleLine, Structured, SynopsisDocumentation
      -- diagnosticsDelay = "1s",          -- Delay before running deep diagnostics
      -- diagnosticsTrigger = "Edit",      -- When to trigger diagnostics: "Edit" or "Save"
      -- analysisProgressReporting = true, -- Show progress for workspace indexing
      linksInHover = true, -- Show clickable links in hover markdown
      -- linkTarget = "pkg.go.dev",         -- Base URL for doc links: "pkg.go.dev" or "godoc.org"
      completeFunctionCalls = true, -- Suggest function calls with parentheses
      -- completionBudget = "100ms",        -- Soft latency target (debugging); "0" for unlimited
      vulncheck = 'Imports', -- Vulnerability mode: "Off" or "Imports"
      deepCompletion = true, -- Suggest deep completions inside nested structs
      completionDocumentation = true, -- Include doc comments in completion items

      -- verboseWorkDoneProgress = false,  -- Report progress notifications
      -- experimentalDiagnosticsDelay = "250ms",  -- Delay for experimental diagnostics
    },
  },
}
