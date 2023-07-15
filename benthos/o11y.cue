package benthos

// This is our own augmentation to the Benthos schema that was generated with
// `benthos list --format cue`. We want all our configs to have good
// observability defaults.

#Config: {
  logger: {
    level: string | *"${LOG_LEVEL:info}"
    format: string | *"${LOG_FORMAT:json}"
    add_timestamp: bool | *true
    timestamp_name: string | *"ts"
  }

  metrics: prometheus: {
    use_histogram_timing: bool | *true
    add_process_metrics: bool | *true
    add_go_metrics: bool | *true
  }
}