package pubsub

input: gcp_pubsub: {
	project:      "my-project"
	subscription: "my-subscription"
}

pipeline: processors: [
	{
		json_schema: schema_path: "./message-schema.json"
	},
]

output:
	retry: {
		max_retries: 5

		output: gcp_cloud_storage: {
			bucket: "gs://a-bucket-to-nowhere"
			path:   "${! @batch_path }"
			batching: {
				count: 1000
				processors: [
					{
						archive: format: "lines"
					},
					{
						mapping: """
							let hash = content().hash("xxhash64").encode("hex")
							meta batch_path = "batches/%s.txt".format(hash)
							"""
					},
				]
			}
		}
	}
