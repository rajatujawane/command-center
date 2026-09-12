# Development project register

This directory maps a product to the inputs a future development runner needs. It is separate from the existing agent-specific blog and outreach configuration.

Validate a register entry without launching anything:

```sh
engine/runner/validate-project.sh projects/termstack.json
```

Check whether an entry is ready for dispatch:

```sh
engine/runner/validate-project.sh --for-dispatch projects/termstack.json
```

Dispatch validation is deliberately fail-closed. It requires dispatch to be explicitly enabled and rejects missing Linear IDs, working-instructions URL, release branch, test commands, test environment, artifact path, notification route, allowed actions or release policy. Validation never opens or modifies the product repository.

The initial TermStack entry is disabled. Its Linear IDs and repository URL were read back from the connected Linear project and Working instructions document. Test commands, test environment, artifact path, release branch, notification route, allowed actions and release policy remain unknown. Do not fill them by inference, and do not enable dispatch as part of Step 4.

`protected-references.json` is the append-only registry read back from `Varr Labs — Reference library and setup`. Its 12 UUIDs must remain protected even if an issue's title, status or labels change.
