package tasks

import (
	"tool/exec"
	"tool/file"
)

command: generateBenthosSchema: {
	gen: exec.Run & {
		cmd: ["benthos", "list", "--format", "cue"]
		stdout:  string
		success: true
	}

	ensureSchemaDir: file.Mkdir & {
		$afer: gen

		path: "./benthos"
	}

	writeSchema: file.Create & {
		$after: ensureSchemaDir

		filename: "./benthos/schema.cue"
		contents: gen.stdout
	}
}
