# Using CUE and Benthos

This repository showcases how to manage multiple Benthos configs by using CUE to
ensure each config is valid and then by using CUE "commands" to export them to
YAML files.

## Before you begin

Ensure you have CUE and Benthos installed and available on your `PATH`.

## Usage

To get the right Benthos schema for the version you have installed, run:

```
cue cmd generateBenthosSchema
```

You can edit the config files under `pipelines/` and when you're ready run:

```
cue cmd exportAll
```

If you want to add more benthos configs, then add an entry for each config in
`tasks/export_tool.cue` under `command.exportAll.targets`.

Try messing with Benthos configs in a way that will trip CUE's type system. When
running `cue cmd exportAll`, you should see appropriate error messages.
