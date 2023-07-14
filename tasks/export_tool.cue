package tasks

import (
	p "path"
	"encoding/yaml"
	"tool/file"

	"github.com/disintegrator/benthos-cue/benthos"
	"github.com/disintegrator/benthos-cue/pipelines/hello"
	"github.com/disintegrator/benthos-cue/pipelines/pubsub"

)

os: p.OS | *p.Unix @tag(os)

command: export: t={
	filename: string
	config:   benthos.#Config

	mkdir: file.MkdirAll & {
		path: p.Dir(t.filename, os)
	}

	echo: file.Create & {
		$after: mkdir

		filename: t.filename
		contents: yaml.Marshal(t.config)
	}
}

command: exportAll: {
	targets: [
		{filename: "./dist/pipelines/hello/config.yml", config:  hello},
		{filename: "./dist/pipelines/pubsub/config.yml", config: pubsub},
	]

	for t in targets {
		(t.filename): command.export & t
	}
}
