package benthos

#Config: {
	// Configures the service-wide HTTP server.
	http?: {
		// Whether to enable to HTTP server.
		enabled?: bool
		// The address to bind to.
		address?: string
		// Specifies a general prefix for all endpoints, this can help isolate the service endpoints when using a reverse proxy with other shared services. All endpoints will still be registered at the root as well as behind the prefix, e.g. with a root_path set to `/foo` the endpoint `/version` will be accessible from both `/version` and `/foo/version`.
		root_path?: string
		// Whether to register a few extra endpoints that can be useful for debugging performance or behavioral problems.
		debug_endpoints?: bool
		// An optional certificate file for enabling TLS.
		cert_file?: string
		// An optional key file for enabling TLS.
		key_file?: string
		// Adds Cross-Origin Resource Sharing headers.
		cors?: {
			// Whether to allow CORS requests.
			enabled?: bool
			// An explicit list of origins that are allowed for CORS requests.
			allowed_origins?: [...string]
		}
		// Allows you to enforce and customise basic authentication for requests to the HTTP server.
		basic_auth?: {
			// Enable basic authentication
			enabled?: bool
			// Custom realm name
			realm?: string
			// Username required to authenticate.
			username?: string
			// Hashed password required to authenticate. (base64 encoded)
			password_hash?: string
			// Encryption algorithm used to generate `password_hash`.
			algorithm?: string
			// Salt for scrypt algorithm. (base64 encoded)
			salt?: string
		}
	}
	// An input to source messages from.
	input?: #Input
	// An optional buffer to store messages during transit.
	buffer?: #Buffer
	// Describes optional processing pipelines used for mutating messages.
	pipeline?: {
		// The number of threads to execute processing pipelines across.
		threads?: int
		// A list of processors to apply to messages.
		processors?: [...#Processor]
	}
	// An output to sink messages to.
	output?: #Output
	// A list of input resources, each must have a unique label.
	input_resources?: [...#Input]
	// A list of processor resources, each must have a unique label.
	processor_resources?: [...#Processor]
	// A list of output resources, each must have a unique label.
	output_resources?: [...#Output]
	// A list of cache resources, each must have a unique label.
	cache_resources?: [...#Cache]
	// A list of rate limit resources, each must have a unique label.
	rate_limit_resources?: [...#RateLimit]
	// Describes how operational logs should be emitted.
	logger?: {
		// Set the minimum severity level for emitting logs.
		level?: string
		// Set the format of emitted logs.
		format?: string
		// Whether to include timestamps in logs.
		add_timestamp?: bool
		// The name of the level field added to logs when the `format` is `json`.
		level_name?: string
		// The name of the timestamp field added to logs when `add_timestamp` is set to `true` and the `format` is `json`.
		timestamp_name?: string
		// The name of the message field added to logs when the the `format` is `json`.
		message_name?: string
		// A map of key/value pairs to add to each structured log.
		static_fields?: {
			[string]: string
		}
		// Experimental: Specify fields for optionally writing logs to a file.
		file?: {
			// The file path to write logs to, if the file does not exist it will be created. Leave this field empty or unset to disable file based logging.
			path?: string
			// Whether to rotate log files automatically.
			rotate?: bool
			// The maximum number of days to retain old log files based on the timestamp encoded in their filename, after which they are deleted. Setting to zero disables this mechanism.
			rotate_max_age_days?: int
		}
	}
	// A mechanism for exporting metrics.
	metrics?: #Metric
	// A mechanism for exporting traces.
	tracer?: #Tracer
	// A period of time to wait for metrics and traces to be pulled or pushed from the process.
	shutdown_delay?: string
	// The maximum period of time to wait for a clean shutdown. If this time is exceeded Benthos will forcefully close.
	shutdown_timeout?: string
	// A list of one or more unit tests to execute.
	tests: [...{
		// The name of the test, this should be unique and give a rough indication of what behaviour is being tested.
		name: string
		// An optional map of environment variables to set for the duration of the test.
		environment?: {
			[string]: string
		}
		// A [JSON Pointer][json-pointer] that identifies the specific processors which should be executed by the test. The target can either be a single processor or an array of processors. Alternatively a resource label can be used to identify a processor.
		// 
		// It is also possible to target processors in a separate file by prefixing the target with a path relative to the test file followed by a # symbol.
		target_processors?: string
		// A file path relative to the test definition path of a Bloblang file to execute as an alternative to testing processors with the `target_processors` field. This allows you to define unit tests for Bloblang mappings directly.
		target_mapping?: string
		// An optional map of processors to mock. Keys should contain either a label or a JSON pointer of a processor that should be mocked. Values should contain a processor definition, which will replace the mocked processor. Most of the time you'll want to use a [`mapping` processor][processors.mapping] here, and use it to create a result that emulates the target processor.
		mocks?: {
			[string]: _
		}
		// Define a batch of messages to feed into your test, specify either an `input_batch` or a series of `input_batches`.
		input_batch?: [...{
			// The raw content of the input message.
			content?: string
			// Sets the raw content of the message to a JSON document matching the structure of the value.
			json_content?: _
			// Sets the raw content of the message by reading a file. The path of the file should be relative to the path of the test file.
			file_content?: string
			// A map of metadata key/values to add to the input message.
			metadata?: {
				[string]: _
			}
		}]
		// Define a series of batches of messages to feed into your test, specify either an `input_batch` or a series of `input_batches`.
		input_batches?: [[...{
			// The raw content of the input message.
			content?: string
			// Sets the raw content of the message to a JSON document matching the structure of the value.
			json_content?: _
			// Sets the raw content of the message by reading a file. The path of the file should be relative to the path of the test file.
			file_content?: string
			// A map of metadata key/values to add to the input message.
			metadata?: {
				[string]: string
			}
		}]]
		// List of output batches.
		output_batches?: [[...{
			// The raw content of the input message.
			content?: string
			// A map of metadata key/values to add to the input message.
			metadata?: {
				[string]: _
			}
			// Executes a Bloblang mapping on the output message, if the result is anything other than a boolean equalling `true` the test fails.
			bloblang?: string
			// Checks the full raw contents of a message against a value.
			content_equals?: string
			// Checks whether the full raw contents of a message matches a regular expression (re2).
			content_matches?: string
			// Checks a map of metadata keys to values against the metadata stored in the message. If there is a value mismatch between a key of the condition versus the message metadata this condition will fail.
			metadata_equals?: {
				[string]: _
			}
			// Checks that the contents of a message matches the contents of a file. The path of the file should be relative to the path of the test file.
			file_equals?: string
			// Checks that both the message and the file contents are valid JSON documents, and that they are structurally equivalent. Will ignore formatting and ordering differences. The path of the file should be relative to the path of the test file.
			file_json_equals?: string
			// Checks that both the message and the condition are valid JSON documents, and that they are structurally equivalent. Will ignore formatting and ordering differences.
			json_equals?: _
			// Checks that both the message and the condition are valid JSON documents, and that the message is a superset of the condition.
			json_contains?: _
			// Checks that both the message and the file contents are valid JSON documents, and that the message is a superset of the condition. Will ignore formatting and ordering differences. The path of the file should be relative to the path of the test file.
			file_json_contains?: string
		}]]
	}]
}
#AllInputs: {
	// Connects to an AMQP (0.91) queue. AMQP is a messaging protocol used by various message brokers, including RabbitMQ.
	amqp_0_9: {
		// A list of URLs to connect to. The first URL to successfully establish a connection will be used until the connection is closed. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// An AMQP queue to consume from.
		queue: string
		// Allows you to passively declare the target queue. If the queue already exists then the declaration passively verifies that they match the target fields.
		queue_declare?: {
			// Whether to enable queue declaration.
			enabled?: bool
			// Whether the declared queue is durable.
			durable?: bool
			// Whether the declared queue will auto-delete.
			auto_delete?: bool
		}
		// Allows you to passively declare bindings for the target queue.
		bindings_declare?: [...{
			// The exchange of the declared binding.
			exchange?: string
			// The key of the declared binding.
			key?: string
		}]
		// A consumer tag.
		consumer_tag?: string
		// Acknowledge messages automatically as they are consumed rather than waiting for acknowledgments from downstream. This can improve throughput and prevent the pipeline from blocking but at the cost of eliminating delivery guarantees.
		auto_ack?: bool
		// A list of regular expression patterns whereby if a message that has failed to be delivered by Benthos has an error that matches it will be dropped (or delivered to a dead-letter queue if one exists). By default failed messages are nacked with requeue enabled.
		nack_reject_patterns?: [...string]
		// The maximum number of pending messages to have consumed at a time.
		prefetch_count?: int
		// The maximum amount of pending messages measured in bytes to have consumed at a time.
		prefetch_size?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
	}
	// Reads messages from an AMQP (1.0) server.
	amqp_1: {
		// A URL to connect to.
		url: string
		// The source address to consume from.
		source_address: string
		// Experimental: Azure service bus specific option to renew lock if processing takes more then configured lock time
		azure_renew_lock?: bool
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Enables SASL authentication.
		sasl?: {
			// The SASL authentication mechanism to use.
			mechanism?: string
			// A SASL plain text username. It is recommended that you use environment variables to populate this field.
			user?: string
			// A SASL plain text password. It is recommended that you use environment variables to populate this field.
			password?: string
		}
	}
	// Receive messages from one or more Kinesis streams.
	aws_kinesis: {
		// One or more Kinesis data streams to consume from. Shards of a stream are automatically balanced across consumers by coordinating through the provided DynamoDB table. Multiple comma separated streams can be listed in a single element. Shards are automatically distributed across consumers of a stream by coordinating through the provided DynamoDB table. Alternatively, it's possible to specify an explicit shard to consume from with a colon after the stream name, e.g. `foo:0` would consume the shard `0` of the stream `foo`.
		streams: [...string]
		// Determines the table used for storing and accessing the latest consumed sequence for shards, and for coordinating balanced consumers of streams.
		dynamodb?: {
			// The name of the table to access.
			table?: string
			// Whether, if the table does not exist, it should be created.
			create?: bool
			// When creating the table determines the billing mode.
			billing_mode?: string
			// Set the provisioned read capacity when creating the table with a `billing_mode` of `PROVISIONED`.
			read_capacity_units?: int
			// Set the provisioned write capacity when creating the table with a `billing_mode` of `PROVISIONED`.
			write_capacity_units?: int
		}
		// The maximum gap between the in flight sequence versus the latest acknowledged sequence at a given time. Increasing this limit enables parallel processing and batching at the output level to work on individual shards. Any given sequence will not be committed unless all messages under that offset are delivered in order to preserve at least once delivery guarantees.
		checkpoint_limit?: int
		// The period of time between each update to the checkpoint table.
		commit_period?: string
		// The period of time between each attempt to rebalance shards across clients.
		rebalance_period?: string
		// The period of time after which a client that has failed to update a shard checkpoint is assumed to be inactive.
		lease_period?: string
		// Whether to consume from the oldest message when a sequence does not yet exist for the stream.
		start_from_oldest?: bool
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Downloads objects within an Amazon S3 bucket, optionally filtered by a prefix, either by walking the items in the bucket or by streaming upload notifications in realtime.
	aws_s3: {
		// The bucket to consume from. If the field `sqs.url` is specified this field is optional.
		bucket?: string
		// An optional path prefix, if set only objects with the prefix are consumed when walking a bucket.
		prefix?: string
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
		// Forces the client API to use path style URLs for downloading keys, which is often required when connecting to custom endpoints.
		force_path_style_urls?: bool
		// Whether to delete downloaded objects from the bucket once they are processed.
		delete_objects?: bool
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// The largest token size expected when consuming objects with a tokenised codec such as `lines`.
		max_buffer?: int
		// Consume SQS messages in order to trigger key downloads.
		sqs?: {
			// An optional SQS URL to connect to. When specified this queue will control which objects are downloaded.
			url?: string
			// A custom endpoint to use when connecting to SQS.
			endpoint?: string
			// A [dot path](/docs/configuration/field_paths) whereby object keys are found in SQS messages.
			key_path?: string
			// A [dot path](/docs/configuration/field_paths) whereby the bucket name can be found in SQS messages.
			bucket_path?: string
			// A [dot path](/docs/configuration/field_paths) of a field to extract an enveloped JSON payload for further extracting the key and bucket from SQS messages. This is specifically useful when subscribing an SQS queue to an SNS topic that receives bucket events.
			envelope_path?: string
			// An optional period of time to wait from when a notification was originally sent to when the target key download is attempted.
			delay_period?: string
			// The maximum number of SQS messages to consume from each request.
			max_messages?: int
			// Whether to set the wait time. Enabling this activates long-polling. Valid values: 0 to 20.
			wait_time_seconds?: int
		}
	}
	// Consume messages from an AWS SQS URL.
	aws_sqs: {
		// The SQS URL to consume from.
		url: string
		// Whether to delete the consumed message once it is acked. Disabling allows you to handle the deletion using a different mechanism.
		delete_message?: bool
		// Whether to set the visibility timeout of the consumed message to zero once it is nacked. Disabling honors the preset visibility timeout specified for the queue.
		reset_visibility?: bool
		// The maximum number of messages to return on one poll. Valid values: 1 to 10.
		max_number_of_messages?: int
		// Whether to set the wait time. Enabling this activates long-polling. Valid values: 0 to 20.
		wait_time_seconds?: int
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
	}
	// Downloads objects within an Azure Blob Storage container, optionally filtered by a prefix.
	azure_blob_storage: {
		// The storage account to access. This field is ignored if `storage_connection_string` is set.
		storage_account?: string
		// The storage account access key. This field is ignored if `storage_connection_string` is set.
		storage_access_key?: string
		// The storage account SAS token. This field is ignored if `storage_connection_string` or `storage_access_key` are set.
		storage_sas_token?: string
		// A storage account connection string. This field is required if `storage_account` and `storage_access_key` / `storage_sas_token` are not set.
		storage_connection_string?: string
		// The name of the container from which to download blobs.
		container: string
		// An optional path prefix, if set only objects with the prefix are consumed.
		prefix?: string
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// Whether to delete downloaded objects from the blob once they are processed.
		delete_objects?: bool
	}
	// Dequeue objects from an Azure Storage Queue.
	azure_queue_storage: {
		// The storage account to access. This field is ignored if `storage_connection_string` is set.
		storage_account?: string
		// The storage account access key. This field is ignored if `storage_connection_string` is set.
		storage_access_key?: string
		// A storage account connection string. This field is required if `storage_account` and `storage_access_key` / `storage_sas_token` are not set.
		storage_connection_string?: string
		// The name of the source storage queue.
		queue_name: string
		// The timeout duration until a dequeued message gets visible again, 30s by default
		dequeue_visibility_timeout?: string
		// The maximum number of unprocessed messages to fetch at a given time.
		max_in_flight?: int
		// If set to `true` the queue is polled on each read request for information such as the queue message lag. These properties are added to consumed messages as metadata, but will also have a negative performance impact.
		track_properties?:  bool
		storage_sas_token?: string
	}
	// Queries an Azure Storage Account Table, optionally with multiple filters.
	azure_table_storage: {
		// The storage account to access. This field is ignored if `storage_connection_string` is set.
		storage_account?: string
		// The storage account access key. This field is ignored if `storage_connection_string` is set.
		storage_access_key?: string
		// A storage account connection string. This field is required if `storage_account` and `storage_access_key` / `storage_sas_token` are not set.
		storage_connection_string?: string
		// The table to read messages from.
		table_name: string
		// OData filter expression. Is not set all rows are returned. Valid operators are `eq, ne, gt, lt, ge and le`
		filter?: string
		// Select expression using OData notation. Limits the columns on each record to just those requested.
		select?: string
		// Maximum number of records to return on each page.
		page_size?: int
	}
	// Consumes data from a child input and applies a batching policy to the stream.
	batched: {
		// The child input.
		child?: #Input
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		policy?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Reads messages from a Beanstalkd queue.
	beanstalkd: {
		// An address to connect to.
		address: string
	}
	// Allows you to combine multiple inputs into a single stream of data, where each input will be read in parallel.
	broker: {
		// Whatever is specified within `inputs` will be created this many times.
		copies?: int
		// A list of inputs to create.
		inputs?: [...#Input]
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Executes a find query and creates a message for each row received.
	cassandra: {
		// A list of Cassandra nodes to connect to.
		addresses: [...string]
		// Optional configuration of Cassandra authentication parameters.
		password_authenticator?: {
			// Whether to use password authentication
			enabled?: bool
			// A username
			username?: string
			// A password
			password?: string
		}
		// If enabled the driver will not attempt to get host info from the system.peers table. This can speed up queries but will mean that data_centre, rack and token information will not be available.
		disable_initial_host_lookup?: bool
		// A query to execute.
		query: string
		// The maximum number of retries before giving up on a request.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
		}
		timeout?: string
	}
	// Reads one or more CSV files as structured records following the format described in RFC 4180.
	csv: {
		// A list of file paths to read from. Each file will be read sequentially until the list is exhausted, at which point the input will close. Glob patterns are supported, including super globs (double star).
		paths: [...string]
		// Whether to reference the first row as a header row. If set to true the output structure for messages will be an object where field keys are determined by the header row. Otherwise, each message will consist of an array of values from the corresponding CSV row.
		parse_header_row?: bool
		// The delimiter to use for splitting values in each record. It must be a single character.
		delimiter?: string
		// If set to `true`, a quote may appear in an unquoted field and a non-doubled quote may appear in a quoted field.
		lazy_quotes?: bool
		// Whether to delete input files from the disk once they are fully consumed.
		delete_on_finish?: bool
		// Optionally process records in batches. This can help to speed up the consumption of exceptionally large CSV files. When the end of the file is reached the remaining records are processed as a (potentially smaller) batch.
		batch_count?: int
	}
	// Consumes messages posted in a Discord channel.
	discord: {
		// A discord channel ID to consume messages from.
		channel_id: string
		// A bot token used for authentication.
		bot_token: string
		// A cache resource to use for performing unread message backfills, the ID of the last message received will be stored in this cache and used for subsequent requests.
		cache: string
		// The key identifier used when storing the ID of the last message received.
		cache_key?: string
		// The length of time (as a duration string) to wait between each poll for backlogged messages. This field can be set empty, in which case requests are made at the limit set by the rate limit. This field also supports cron expressions.
		poll_period?: string
		// The maximum number of messages to receive in a single request.
		limit?:      int
		rate_limit?: string
	}
	// A special broker type where the inputs are identified by unique labels and can be created, changed and removed during runtime via a REST HTTP interface.
	dynamic: {
		// A map of inputs to statically create.
		inputs?: {
			[string]: #Input
		}
		// A path prefix for HTTP endpoints that are registered.
		prefix?: string
	}
	// Consumes data from files on disk, emitting messages according to a chosen codec.
	file: {
		// A list of paths to consume sequentially. Glob patterns are supported, including super globs (double star).
		paths: [...string]
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// The largest token size expected when consuming files with a tokenised codec such as `lines`.
		max_buffer?: int
		// Whether to delete input files from the disk once they are fully consumed.
		delete_on_finish?: bool
	}
	// Executes a `SELECT` query against BigQuery and creates a message for each row received.
	gcp_bigquery_select: {
		// GCP project where the query job will execute.
		project: string
		// Fully-qualified BigQuery table name to query.
		table: string
		// A list of columns to query.
		columns: [...string]
		// An optional where clause to add. Placeholder arguments are populated with the `args_mapping` field. Placeholders should always be question marks (`?`).
		where?: string
		// A list of labels to add to the query job.
		job_labels?: {
			[string]: string
		}
		// The priority with which to schedule the query.
		priority?: string
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `where`.
		args_mapping?: string
		// An optional prefix to prepend to the select query (before SELECT).
		prefix?: string
		// An optional suffix to append to the select query.
		suffix?: string
	}
	// Downloads objects within a Google Cloud Storage bucket, optionally filtered by a prefix.
	gcp_cloud_storage: {
		// The name of the bucket from which to download objects.
		bucket: string
		// An optional path prefix, if set only objects with the prefix are consumed.
		prefix?: string
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// Whether to delete downloaded objects from the bucket once they are processed.
		delete_objects?: bool
	}
	// Consumes messages from a GCP Cloud Pub/Sub subscription.
	gcp_pubsub: {
		// The project ID of the target subscription.
		project: string
		// The target subscription ID.
		subscription: string
		// An optional endpoint to override the default of `pubsub.googleapis.com:443`. This can be used to connect to a region specific pubsub endpoint. For a list of valid values check out [this document.](https://cloud.google.com/pubsub/docs/reference/service_apis_overview#list_of_regional_endpoints)
		endpoint?: string
		// Enable synchronous pull mode.
		sync?: bool
		// The maximum number of outstanding pending messages to be consumed at a given time.
		max_outstanding_messages?: int
		// The maximum number of outstanding pending messages to be consumed measured in bytes.
		max_outstanding_bytes?: int
		// Allows you to configure the input subscription and creates if it doesn't exist.
		create_subscription?: {
			// Whether to configure subscription or not.
			enabled?: bool
			// Defines the topic that the subscription should be vinculated to.
			topic?: string
		}
	}
	// Generates messages at a given interval using a [Bloblang](/docs/guides/bloblang/about)
	// mapping executed without a context. This allows you to generate messages for
	// testing your pipeline configs.
	generate: {
		// A [bloblang](/docs/guides/bloblang/about) mapping to use for generating messages.
		mapping?: string
		// The time interval at which messages should be generated, expressed either as a duration string or as a cron expression. If set to an empty string messages will be generated as fast as downstream services can process them. Cron expressions can specify a timezone by prefixing the expression with `TZ=<location name>`, where the location name corresponds to a file within the IANA Time Zone database.
		interval?: string
		// An optional number of messages to generate, if set above 0 the specified number of messages is generated and then the input will shut down.
		count?: int
		// The number of generated messages that should be accumulated into each batch flushed at the specified interval.
		batch_size?: int
	}
	// Reads files from a HDFS directory, where each discrete file will be consumed as a single message payload.
	hdfs: {
		// A list of target host addresses to connect to.
		hosts: [...string]
		// A user ID to connect as.
		user?: string
		// The directory to consume from.
		directory: string
	}
	// Connects to a server and continuously performs requests for a single message.
	http_client: {
		// The URL to connect to.
		url: string
		// A verb to connect with
		verb?: string
		// A map of headers to add to the request.
		headers?: {
			[string]: string
		}
		// Specify optional matching rules to determine which metadata keys should be added to the HTTP request as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to match against.
			include_prefixes?: [...string]
			// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
			include_patterns?: [...string]
		}
		// EXPERIMENTAL: Optionally set a level at which the request and response payload of each request made will be logged.
		dump_request_log_level?: string
		// Allows you to specify open authentication via OAuth version 1.
		oauth?: {
			// Whether to use OAuth version 1 in requests.
			enabled?: bool
			// A value used to identify the client to the service provider.
			consumer_key?: string
			// A secret used to establish ownership of the consumer key.
			consumer_secret?: string
			// A value used to gain access to the protected resources on behalf of the user.
			access_token?: string
			// A secret provided in order to establish ownership of a given access token.
			access_token_secret?: string
		}
		// Allows you to specify open authentication via OAuth version 2 using the client credentials token flow.
		oauth2?: {
			// Whether to use OAuth version 2 in requests.
			enabled?: bool
			// A value used to identify the client to the token provider.
			client_key?: string
			// A secret used to establish ownership of the client key.
			client_secret?: string
			// The URL of the token provider.
			token_url?: string
			// A list of optional requested permissions.
			scopes?: [...string]
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// BETA: Allows you to specify JWT authentication.
		jwt?: {
			// Whether to use JWT authentication in requests.
			enabled?: bool
			// A file with the PEM encoded via PKCS1 or PKCS8 as private key.
			private_key_file?: string
			// A method used to sign the token such as RS256, RS384, RS512 or EdDSA.
			signing_method?: string
			// A value used to identify the claims that issued the JWT.
			claims?: {
				[string]: _
			}
			// Add optional key/value headers to the JWT.
			headers?: {
				[string]: _
			}
		}
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Specify which response headers should be added to resulting messages as metadata. Header keys are lowercased before matching, so ensure that your patterns target lowercased versions of the header keys that you expect.
		extract_headers?: {
			// Provide a list of explicit metadata key prefixes to match against.
			include_prefixes?: [...string]
			// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
			include_patterns?: [...string]
		}
		// An optional [rate limit](/docs/components/rate_limits/about) to throttle requests by.
		rate_limit?: string
		// A static timeout to apply to requests.
		timeout?: string
		// The base period to wait between failed requests.
		retry_period?: string
		// The maximum period to wait between failed requests.
		max_retry_backoff?: string
		// The maximum number of retry attempts to make.
		retries?: int
		// A list of status codes whereby the request should be considered to have failed and retries should be attempted, but the period between them should be increased gradually.
		backoff_on?: [...int]
		// A list of status codes whereby the request should be considered to have failed but retries should not be attempted. This is useful for preventing wasted retries for requests that will never succeed. Note that with these status codes the _request_ is dropped, but _message_ that caused the request will not be dropped.
		drop_on?: [...int]
		// A list of status codes whereby the attempt should be considered successful, this is useful for dropping requests that return non-2XX codes indicating that the message has been dealt with, such as a 303 See Other or a 409 Conflict. All 2XX codes are considered successful unless they are present within `backoff_on` or `drop_on`, regardless of this field.
		successful_on?: [...int]
		// An optional HTTP proxy URL.
		proxy_url?: string
		// An optional payload to deliver for each request.
		payload?: string
		// Whether empty payloads received from the target server should be dropped.
		drop_empty_bodies?: bool
		// Allows you to set streaming mode, where requests are kept open and messages are processed line-by-line.
		stream?: {
			// Enables streaming mode.
			enabled?: bool
			// Sets whether to re-establish the connection once it is lost.
			reconnect?: bool
			// The way in which the bytes of a continuous stream are converted into messages. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. It's not necessary to add gzip in the codec when the response headers specify it as it will be decompressed automatically.
			codec?: string
			// Must be larger than the largest line of the stream.
			max_buffer?: int
		}
	}
	// Receive messages POSTed over HTTP(S). HTTP 2.0 is supported when using TLS, which is enabled when key and cert files are specified.
	http_server: {
		// An alternative address to host from. If left empty the service wide address is used.
		address?: string
		// The endpoint path to listen for POST requests.
		path?: string
		// The endpoint path to create websocket connections from.
		ws_path?: string
		// An optional message to deliver to fresh websocket connections.
		ws_welcome_message?: string
		// An optional message to delivery to websocket connections that are rate limited.
		ws_rate_limit_message?: string
		// An array of verbs that are allowed for the `path` endpoint.
		allowed_verbs?: [...string]
		// Timeout for requests. If a consumed messages takes longer than this to be delivered the connection is closed, but the message may still be delivered.
		timeout?: string
		// An optional [rate limit](/docs/components/rate_limits/about) to throttle requests by.
		rate_limit?: string
		// Enable TLS by specifying a certificate and key file. Only valid with a custom `address`.
		cert_file?: string
		// Enable TLS by specifying a certificate and key file. Only valid with a custom `address`.
		key_file?: string
		// Adds Cross-Origin Resource Sharing headers. Only valid with a custom `address`.
		cors?: {
			// Whether to allow CORS requests.
			enabled?: bool
			// An explicit list of origins that are allowed for CORS requests.
			allowed_origins?: [...string]
		}
		// Customise messages returned via [synchronous responses](/docs/guides/sync_responses).
		sync_response?: {
			// Specify the status code to return with synchronous responses. This is a string value, which allows you to customize it based on resulting payloads and their metadata.
			status?: string
			// Specify headers to return with synchronous responses.
			headers?: {
				[string]: string
			}
			// Specify criteria for which metadata values are added to the response as headers.
			metadata_headers?: {
				// Provide a list of explicit metadata key prefixes to match against.
				include_prefixes?: [...string]
				// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
				include_patterns?: [...string]
			}
		}
	}
	inproc: string
	// Connects to Kafka brokers and consumes one or more topics.
	kafka: {
		// A list of broker addresses to connect to. If an item of the list contains commas it will be expanded into multiple addresses.
		addresses?: [...string]
		// A list of topics to consume from. Multiple comma separated topics can be listed in a single element. Partitions are automatically distributed across consumers of a topic. Alternatively, it's possible to specify explicit partitions to consume from with a colon after the topic name, e.g. `foo:0` would consume the partition 0 of the topic foo. This syntax supports ranges, e.g. `foo:0-10` would consume partitions 0 through to 10 inclusive.
		topics?: [...string]
		// The version of the Kafka protocol to use. This limits the capabilities used by the client and should ideally match the version of your brokers.
		target_version?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Enables SASL authentication.
		sasl?: {
			// The SASL authentication mechanism, if left empty SASL authentication is not used. Warning: SCRAM based methods within Benthos have not received a security audit.
			mechanism?: string
			// A PLAIN username. It is recommended that you use environment variables to populate this field.
			user?: string
			// A PLAIN password. It is recommended that you use environment variables to populate this field.
			password?: string
			// A static OAUTHBEARER access token
			access_token?: string
			// Instead of using a static `access_token` allows you to query a [`cache`](/docs/components/caches/about) resource to fetch OAUTHBEARER tokens from
			token_cache?: string
			// Required when using a `token_cache`, the key to query the cache with for tokens.
			token_key?: string
		}
		// An identifier for the consumer group of the connection. This field can be explicitly made empty in order to disable stored offsets for the consumed topic partitions.
		consumer_group?: string
		// An identifier for the client connection.
		client_id?: string
		// A rack identifier for this client.
		rack_id?: string
		// Determines whether to consume from the oldest available offset, otherwise messages are consumed from the latest offset. The setting is applied when creating a new consumer group or the saved offset no longer exists.
		start_from_oldest?: bool
		// The maximum number of messages of the same topic and partition that can be processed at a given time. Increasing this limit enables parallel processing and batching at the output level to work on individual partitions. Any given offset will not be committed unless all messages under that offset are delivered in order to preserve at least once delivery guarantees.
		checkpoint_limit?: int
		// The period of time between each commit of the current partition offsets. Offsets are always committed during shutdown.
		commit_period?: string
		// A maximum estimate for the time taken to process a message, this is used for tuning consumer group synchronization.
		max_processing_period?: string
		// EXPERIMENTAL: A [Bloblang mapping](/docs/guides/bloblang/about) that attempts to extract an object containing tracing propagation information, which will then be used as the root tracing span for the message. The specification of the extracted fields must match the format used by the service wide tracer.
		extract_tracing_map?: string
		// Tuning parameters for consumer group synchronization.
		group?: {
			// A period after which a consumer of the group is kicked after no heartbeats.
			session_timeout?: string
			// A period in which heartbeats should be sent out.
			heartbeat_interval?: string
			// A period after which rebalancing is abandoned if unresolved.
			rebalance_timeout?: string
		}
		// The maximum number of unprocessed messages to fetch at a given time.
		fetch_buffer_cap?: int
		// Decode headers into lists to allow handling of multiple values with the same key
		multi_header?: bool
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// A Kafka input using the [Franz Kafka client library](https://github.com/twmb/franz-go).
	kafka_franz: {
		// A list of broker addresses to connect to in order to establish connections. If an item of the list contains commas it will be expanded into multiple addresses.
		seed_brokers: [...string]
		// A list of topics to consume from. Multiple comma separated topics can be listed in a single element. When a `consumer_group` is specified partitions are automatically distributed across consumers of a topic, otherwise all partitions are consumed.
		// 
		// Alternatively, it's possible to specify explicit partitions to consume from with a colon after the topic name, e.g. `foo:0` would consume the partition 0 of the topic foo. This syntax supports ranges, e.g. `foo:0-10` would consume partitions 0 through to 10 inclusive.
		// 
		// Finally, it's also possible to specify an explicit offset to consume from by adding another colon after the partition, e.g. `foo:0:10` would consume the partition 0 of the topic foo starting from the offset 10. If the offset is not present (or remains unspecified) then the field `start_from_oldest` determines which offset to start from.
		topics: [...string]
		// Whether listed topics should be interpreted as regular expression patterns for matching multiple topics. When topics are specified with explicit partitions this field must remain set to `false`.
		regexp_topics?: bool
		// An optional consumer group to consume as. When specified the partitions of specified topics are automatically distributed across consumers sharing a consumer group, and partition offsets are automatically committed and resumed under this name. Consumer groups are not supported when specifying explicit partitions to consume from in the `topics` field.
		consumer_group?: string
		// Determines how many messages of the same partition can be processed in parallel before applying back pressure. When a message of a given offset is delivered to the output the offset is only allowed to be committed when all messages of prior offsets have also been delivered, this ensures at-least-once delivery guarantees. However, this mechanism also increases the likelihood of duplicates in the event of crashes or server faults, reducing the checkpoint limit will mitigate this.
		checkpoint_limit?: int
		// The period of time between each commit of the current partition offsets. Offsets are always committed during shutdown.
		commit_period?: string
		// Determines whether to consume from the oldest available offset, otherwise messages are consumed from the latest offset. The setting is applied when creating a new consumer group or the saved offset no longer exists.
		start_from_oldest?: bool
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Specify one or more methods of SASL authentication. SASL is tried in order; if the broker supports the first mechanism, all connections will use that mechanism. If the first mechanism fails, the client will pick the first supported mechanism. If the broker does not support any client mechanisms, connections will fail.
		sasl?: [...{
			// The SASL mechanism to use.
			mechanism: string
			// A username to provide for PLAIN or SCRAM-* authentication.
			username?: string
			// A password to provide for PLAIN or SCRAM-* authentication.
			password?: string
			// The token to use for a single session's OAUTHBEARER authentication.
			token?: string
			// Key/value pairs to add to OAUTHBEARER authentication requests.
			extensions?: {
				[string]: string
			}
			// Contains AWS specific fields for when the `mechanism` is set to `AWS_MSK_IAM`.
			aws?: {
				// The AWS region to target.
				region?: string
				// Allows you to specify a custom endpoint for the AWS API.
				endpoint?: string
				// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
				credentials?: {
					// A profile from `~/.aws/credentials` to use.
					profile?: string
					// The ID of credentials to use.
					id?: string
					// The secret for the credentials being used.
					secret?: string
					// The token for the credentials being used, required when using short term credentials.
					token?: string
					// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
					from_ec2_role?: bool
					// A role ARN to assume.
					role?: string
					// An external ID to provide when assuming a role.
					role_external_id?: string
				}
			}
		}]
		// Decode headers into lists to allow handling of multiple values with the same key
		multi_header?: bool
		// Allows you to configure a [batching policy](/docs/configuration/batching) that applies to individual topic partitions in order to batch messages together before flushing them for processing. Batching can be beneficial for performance as well as useful for windowed processing, and doing so this way preserves the ordering of topic partitions.
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Executes a find query and creates a message for each row received.
	mongodb: {
		// The URL of the target MongoDB server.
		url: string
		// The name of the target MongoDB database.
		database: string
		// The username to connect to the database.
		username?: string
		// The password to connect to the database.
		password?: string
		// The collection to select from.
		collection: string
		// The mongodb operation to perform.
		operation?: string
		// The json_marshal_mode setting is optional and controls the format of the output message.
		json_marshal_mode?: string
		// Bloblang expression describing MongoDB query.
		query: string
	}
	// Subscribe to topics on MQTT brokers.
	mqtt: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls?: [...string]
		// A list of topics to consume from.
		topics?: [...string]
		// An identifier for the client connection.
		client_id?: string
		// Append a dynamically generated suffix to the specified `client_id` on each run of the pipeline. This can be useful when clustering Benthos producers.
		dynamic_client_id_suffix?: string
		// The level of delivery guarantee to enforce.
		qos?: int
		// Set whether the connection is non-persistent.
		clean_session?: bool
		// Set last will message in case of Benthos failure
		will?: {
			// Whether to enable last will messages.
			enabled?: bool
			// Set QoS for last will message.
			qos?: int
			// Set retained for last will message.
			retained?: bool
			// Set topic for last will message.
			topic?: string
			// Set payload for last will message.
			payload?: string
		}
		// The maximum amount of time to wait in order to establish a connection before the attempt is abandoned.
		connect_timeout?: string
		// A username to assume for the connection.
		user?: string
		// A password to provide for the connection.
		password?: string
		// Max seconds of inactivity before a keepalive message is sent.
		keepalive?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
	}
	// Consumes messages via Nanomsg sockets (scalability protocols).
	nanomsg: {
		// A list of URLs to connect to (or as). If an item of the list contains commas it will be expanded into multiple URLs.
		urls?: [...string]
		// Whether the URLs provided should be connected to, or bound as.
		bind?: bool
		// The socket type to use.
		socket_type?: string
		// A list of subscription topic filters to use when consuming from a SUB socket. Specifying a single sub_filter of `''` will subscribe to everything.
		sub_filters?: [...string]
		// The period to wait until a poll is abandoned and reattempted.
		poll_timeout?: string
	}
	// Subscribe to a NATS subject.
	nats: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// A subject to consume from. Supports wildcards for consuming multiple subjects. Either a subject or stream must be specified.
		subject: string
		// An optional queue group to consume as.
		queue?: string
		// An optional delay duration on redelivering a message when negatively acknowledged.
		nak_delay?: string
		// The maximum number of messages to pull at a time.
		prefetch_count?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Reads messages from NATS JetStream subjects.
	nats_jetstream: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// An optional queue group to consume as.
		queue?: string
		// A subject to consume from. Supports wildcards for consuming multiple subjects. Either a subject or stream must be specified.
		subject?: string
		// Preserve the state of your consumer under a durable name.
		durable?: string
		// A stream to consume from. Either a subject or stream must be specified.
		stream?: string
		// Indicates that the subscription should use an existing consumer.
		bind?: bool
		// Determines which messages to deliver when consuming without a durable subscriber.
		deliver?: string
		// The maximum amount of time NATS server should wait for an ack from consumer.
		ack_wait?: string
		// The maximum number of outstanding acks to be allowed before consuming is halted.
		max_ack_pending?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Watches for updates in a NATS key-value bucket.
	nats_kv: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// The name of the KV bucket to watch for updates.
		bucket: string
		// Key to watch for updates, can include wildcards.
		key?: string
		// Do not send delete markers as messages.
		ignore_deletes?: bool
		// Include all the history per key, not just the last one.
		include_history?: bool
		// Retrieve only the metadata of the entry
		meta_only?: bool
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Subscribe to a NATS Stream subject. Joining a queue is optional and allows multiple clients of a subject to consume using queue semantics.
	nats_stream: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// The ID of the cluster to consume from.
		cluster_id: string
		// A client ID to connect as.
		client_id?: string
		// The queue to consume from.
		queue?: string
		// A subject to consume from.
		subject?: string
		// Preserve the state of your consumer under a durable name.
		durable_name?: string
		// Whether the subscription should be destroyed when this client disconnects.
		unsubscribe_on_close?: bool
		// If a position is not found for a queue, determines whether to consume from the oldest available message, otherwise messages are consumed from the latest.
		start_from_oldest?: bool
		// The maximum number of unprocessed messages to fetch at a given time.
		max_inflight?: int
		// An optional duration to specify at which a message that is yet to be acked will be automatically retried.
		ack_wait?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Subscribe to an NSQ instance topic and channel.
	nsq: {
		// A list of nsqd addresses to connect to.
		nsqd_tcp_addresses?: [...string]
		// A list of nsqlookupd addresses to connect to.
		lookupd_http_addresses?: [...string]
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The topic to consume from.
		topic?: string
		// The channel to consume from.
		channel?: string
		// A user agent to assume when connecting.
		user_agent?: string
		// The maximum number of pending messages to consume at any given time.
		max_in_flight?: int
		// The maximum number of attempts to successfully consume a messages.
		max_attempts?: int
	}
	// Reads and decodes [Parquet files](https://parquet.apache.org/docs/) into a stream of structured messages.
	parquet: {
		// A list of file paths to read from. Each file will be read sequentially until the list is exhausted, at which point the input will close. Glob patterns are supported, including super globs (double star).
		paths: [...string]
		// Optionally process records in batches. This can help to speed up the consumption of exceptionally large files. When the end of the file is reached the remaining records are processed as a (potentially smaller) batch.
		batch_count?: int
	}
	// Reads messages from an Apache Pulsar server.
	pulsar: {
		// A URL to connect to.
		url: string
		// A list of topics to subscribe to.
		topics: [...string]
		// Specify the subscription name for this consumer.
		subscription_name: string
		// Specify the subscription type for this consumer.
		// 
		// > NOTE: Using a `key_shared` subscription type will __allow out-of-order delivery__ since nack-ing messages sets non-zero nack delivery delay - this can potentially cause consumers to stall. See [Pulsar documentation](https://pulsar.apache.org/docs/en/2.8.1/concepts-messaging/#negative-acknowledgement) and [this Github issue](https://github.com/apache/pulsar/issues/12208) for more details.
		subscription_type?: string
		// Specify the path to a custom CA certificate to trust broker TLS service.
		tls?: {
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
		}
		// Optional configuration of Pulsar authentication methods.
		auth?: {
			// Parameters for Pulsar OAuth2 authentication.
			oauth2?: {
				// Whether OAuth2 is enabled.
				enabled?: bool
				// OAuth2 audience.
				audience?: string
				// OAuth2 issuer URL.
				issuer_url?: string
				// The path to a file containing a private key.
				private_key_file?: string
			}
			// Parameters for Pulsar Token authentication.
			token?: {
				// Whether Token Auth is enabled.
				enabled?: bool
				// Actual base64 encoded token.
				token?: string
			}
		}
	}
	// Reads messages from a child input until a consumed message passes a [Bloblang query](/docs/guides/bloblang/about/), at which point the input closes.
	read_until: {
		// The child input to consume from.
		input?: #Input
		// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether the input should now be closed.
		check?: string
		// Whether the input should be reopened if it closes itself before the condition has resolved to true.
		restart_input?: bool
	}
	// Pops messages from the beginning of a Redis list using the BLPop command.
	redis_list: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The key of a list to read from.
		key: string
		// Optionally sets a limit on the number of messages that can be flowing through a Benthos stream pending acknowledgment from the input at any given time. Once a message has been either acknowledged or rejected (nacked) it is no longer considered pending. If the input produces logical batches then each batch is considered a single count against the maximum. **WARNING**: Batching policies at the output level will stall if this field limits the number of messages below the batching threshold. Zero (default) or lower implies no limit.
		max_in_flight?: int
		// The length of time to poll for new messages before reattempting.
		timeout?: string
	}
	// Consume from a Redis publish/subscribe channel using either the SUBSCRIBE or PSUBSCRIBE commands.
	redis_pubsub: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// A list of channels to consume from.
		channels: [...string]
		// Whether to use the PSUBSCRIBE command, allowing for glob-style patterns within target channel names.
		use_patterns?: bool
	}
	// Pulls messages from Redis (v5.0+) streams with the XREADGROUP command. The `client_id` should be unique for each consumer of a group.
	redis_streams: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The field key to extract the raw message from. All other keys will be stored in the message as metadata.
		body_key?: string
		// A list of streams to consume from.
		streams: [...string]
		// The maximum number of messages to consume from a single request.
		limit?: int
		// An identifier for the client connection.
		client_id?: string
		// An identifier for the consumer group of the stream.
		consumer_group?: string
		// Create subscribed streams if they do not exist (MKSTREAM option).
		create_streams?: bool
		// If an offset is not found for a stream, determines whether to consume from the oldest available offset, otherwise messages are consumed from the latest offset.
		start_from_oldest?: bool
		// The period of time between each commit of the current offset. Offsets are always committed during shutdown.
		commit_period?: string
		// The length of time to poll for new messages before reattempting.
		timeout?: string
	}
	// Resource is an input type that channels messages from a resource input, identified by its name.
	resource: string
	// Reads messages from a sequence of child inputs, starting with the first and once
	// that input gracefully terminates starts consuming from the next, and so on.
	sequence: {
		// EXPERIMENTAL: Provides a way to perform outer joins of arbitrarily structured and unordered data resulting from the input sequence, even when the overall size of the data surpasses the memory available on the machine.
		// 
		// When configured the sequence of inputs will be consumed one or more times according to the number of iterations, and when more than one iteration is specified each iteration will process an entirely different set of messages by sharding them by the ID field. Increasing the number of iterations reduces the memory consumption at the cost of needing to fully parse the data each time.
		// 
		// Each message must be structured (JSON or otherwise processed into a structured form) and the fields will be aggregated with those of other messages sharing the ID. At the end of each iteration the joined messages are flushed downstream before the next iteration begins, hence keeping memory usage limited.
		sharded_join?: {
			// The type of join to perform. A `full-outer` ensures that all identifiers seen in any of the input sequences are sent, and is performed by consuming all input sequences before flushing the joined results. An `outer` join consumes all input sequences but only writes data joined from the last input in the sequence, similar to a left or right outer join. With an `outer` join if an identifier appears multiple times within the final sequence input it will be flushed each time it appears. `full-outter` and `outter` have been deprecated in favour of `full-outer` and `outer`.
			type?: string
			// A [dot path](/docs/configuration/field_paths) that points to a common field within messages of each fragmented data set and can be used to join them. Messages that are not structured or are missing this field will be dropped. This field must be set in order to enable joins.
			id_path?: string
			// The total number of iterations (shards), increasing this number will increase the overall time taken to process the data, but reduces the memory used in the process. The real memory usage required is significantly higher than the real size of the data and therefore the number of iterations should be at least an order of magnitude higher than the available memory divided by the overall size of the dataset.
			iterations?: int
			// The chosen strategy to use when a data join would otherwise result in a collision of field values. The strategy `array` means non-array colliding values are placed into an array and colliding arrays are merged. The strategy `replace` replaces old values with new values. The strategy `keep` keeps the old value.
			merge_strategy?: string
		}
		// An array of inputs to read from sequentially.
		inputs?: [...#Input]
	}
	// Consumes files from a server over SFTP.
	sftp: {
		// The address of the server to connect to that has the target files.
		address?: string
		// The credentials to use to log into the server.
		credentials?: {
			// The username to connect to the SFTP server.
			username?: string
			// The password for the username to connect to the SFTP server.
			password?: string
			// The private key for the username to connect to the SFTP server.
			private_key_file?: string
			// Optional passphrase for private key.
			private_key_pass?: string
		}
		// A list of paths to consume sequentially. Glob patterns are supported.
		paths?: [...string]
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// Whether to delete files from the server once they are processed.
		delete_on_finish?: bool
		// The largest token size expected when consuming delimited files.
		max_buffer?: int
		// An experimental mode whereby the input will periodically scan the target paths for new files and consume them, when all files are consumed the input will continue polling for new files.
		watcher?: {
			// Whether file watching is enabled.
			enabled?: bool
			// The minimum period of time since a file was last updated before attempting to consume it. Increasing this period decreases the likelihood that a file will be consumed whilst it is still being written to.
			minimum_age?: string
			// The interval between each attempt to scan the target paths for new files.
			poll_interval?: string
			// A [cache resource](/docs/components/caches/about) for storing the paths of files already consumed.
			cache?: string
		}
	}
	// Connects to a tcp or unix socket and consumes a continuous stream of messages.
	socket: {
		// A network type to assume (unix|tcp).
		network?: string
		// The address to connect to.
		address?: string
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// The maximum message buffer size. Must exceed the largest message to be consumed.
		max_buffer?: int
	}
	// Creates a server that receives a stream of messages over a tcp, udp or unix socket.
	socket_server: {
		// A network type to accept.
		network?: string
		// The address to listen from.
		address?: string
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// The maximum message buffer size. Must exceed the largest message to be consumed.
		max_buffer?: int
		// TLS specific configuration, valid when the `network` is set to `tls`.
		tls?: {
			// PEM encoded certificate for use with TLS.
			cert_file?: string
			// PEM encoded private key for use with TLS.
			key_file?: string
			// Whether to generate self signed certificates.
			self_signed?: bool
		}
	}
	// Executes a select query and creates a message for each row received.
	sql_raw: {
		// A database [driver](#drivers) to use.
		driver: string
		// A Data Source Name to identify the target database.
		// 
		// #### Drivers
		// 
		// The following is a list of supported drivers, their placeholder style, and their respective DSN formats:
		// 
		// | Driver | Data Source Name Format |
		// |---|---|
		// | `clickhouse` | [`clickhouse://[username[:password]@][netloc][:port]/dbname[?param1=value1&...&paramN=valueN]`](https://github.com/ClickHouse/clickhouse-go#dsn) |
		// | `mysql` | `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]` |
		// | `postgres` | `postgres://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]` |
		// | `mssql` | `sqlserver://[user[:password]@][netloc][:port][?database=dbname&param1=value1&...]` |
		// | `sqlite` | `file:/path/to/filename.db[?param&=value1&...]` |
		// | `oracle` | `oracle://[username[:password]@][netloc][:port]/service_name?server=server2&server=server3` |
		// | `snowflake` | `username[:password]@account_identifier/dbname/schemaname[?param1=value&...&paramN=valueN]` |
		// | `trino` | [`http[s]://user[:pass]@host[:port][?parameters]`](https://github.com/trinodb/trino-go-client#dsn-data-source-name)
		// 
		// Please note that the `postgres` driver enforces SSL by default, you can override this with the parameter `sslmode=disable` if required.
		// 
		// The `snowflake` driver supports multiple DSN formats. Please consult [the docs](https://pkg.go.dev/github.com/snowflakedb/gosnowflake#hdr-Connection_String) for more details. For [key pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth.html#configuring-key-pair-authentication), the DSN has the following format: `<snowflake_user>@<snowflake_account>/<db_name>/<schema_name>?warehouse=<warehouse>&role=<role>&authenticator=snowflake_jwt&privateKey=<base64_url_encoded_private_key>`, where the value for the `privateKey` parameter can be constructed from an unencrypted RSA private key file `rsa_key.p8` using `openssl enc -d -base64 -in rsa_key.p8 | basenc --base64url -w0` (you can use `gbasenc` insted of `basenc` on OSX if you install `coreutils` via Homebrew). If you have a password-encrypted private key, you can decrypt it using `openssl pkcs8 -in rsa_key_encrypted.p8 -out rsa_key.p8`. Also, make sure fields such as the username are URL-encoded.
		dsn: string
		// The query to execute. The style of placeholder to use depends on the driver, some drivers require question marks (`?`) whereas others expect incrementing dollar signs (`$1`, `$2`, and so on). The style to use is outlined in this table:
		// 
		// | Driver | Placeholder Style |
		// |---|---|
		// | `clickhouse` | Dollar sign |
		// | `mysql` | Question mark |
		// | `postgres` | Dollar sign |
		// | `mssql` | Question mark |
		// | `sqlite` | Question mark |
		// | `oracle` | Colon |
		// | `snowflake` | Question mark |
		// | `trino` | Question mark |
		query: string
		// A [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of columns specified.
		args_mapping?: string
		// An optional list of file paths containing SQL statements to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Glob patterns are supported, including super globs (double star).
		// 
		// Care should be taken to ensure that the statements are idempotent, and therefore would not cause issues when run multiple times after service restarts. If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If a statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_files?: [...string]
		// An optional SQL statement to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Care should be taken to ensure that the statement is idempotent, and therefore would not cause issues when run multiple times after service restarts.
		// 
		// If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If the statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_statement?: string
		// An optional maximum amount of time a connection may be idle. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's idle time.
		conn_max_idle_time?: string
		// An optional maximum amount of time a connection may be reused. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's age.
		conn_max_life_time?: string
		// An optional maximum number of connections in the idle connection pool. If conn_max_open is greater than 0 but less than the new conn_max_idle, then the new conn_max_idle will be reduced to match the conn_max_open limit. If value <= 0, no idle connections are retained. The default max idle connections is currently 2. This may change in a future release.
		conn_max_idle?: int
		// An optional maximum number of open connections to the database. If conn_max_idle is greater than 0 and the new conn_max_open is less than conn_max_idle, then conn_max_idle will be reduced to match the new conn_max_open limit. If value <= 0, then there is no limit on the number of open connections. The default is 0 (unlimited).
		conn_max_open?: int
	}
	// Executes a select query and creates a message for each row received.
	sql_select: {
		// A database [driver](#drivers) to use.
		driver: string
		// A Data Source Name to identify the target database.
		// 
		// #### Drivers
		// 
		// The following is a list of supported drivers, their placeholder style, and their respective DSN formats:
		// 
		// | Driver | Data Source Name Format |
		// |---|---|
		// | `clickhouse` | [`clickhouse://[username[:password]@][netloc][:port]/dbname[?param1=value1&...&paramN=valueN]`](https://github.com/ClickHouse/clickhouse-go#dsn) |
		// | `mysql` | `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]` |
		// | `postgres` | `postgres://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]` |
		// | `mssql` | `sqlserver://[user[:password]@][netloc][:port][?database=dbname&param1=value1&...]` |
		// | `sqlite` | `file:/path/to/filename.db[?param&=value1&...]` |
		// | `oracle` | `oracle://[username[:password]@][netloc][:port]/service_name?server=server2&server=server3` |
		// | `snowflake` | `username[:password]@account_identifier/dbname/schemaname[?param1=value&...&paramN=valueN]` |
		// | `trino` | [`http[s]://user[:pass]@host[:port][?parameters]`](https://github.com/trinodb/trino-go-client#dsn-data-source-name)
		// 
		// Please note that the `postgres` driver enforces SSL by default, you can override this with the parameter `sslmode=disable` if required.
		// 
		// The `snowflake` driver supports multiple DSN formats. Please consult [the docs](https://pkg.go.dev/github.com/snowflakedb/gosnowflake#hdr-Connection_String) for more details. For [key pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth.html#configuring-key-pair-authentication), the DSN has the following format: `<snowflake_user>@<snowflake_account>/<db_name>/<schema_name>?warehouse=<warehouse>&role=<role>&authenticator=snowflake_jwt&privateKey=<base64_url_encoded_private_key>`, where the value for the `privateKey` parameter can be constructed from an unencrypted RSA private key file `rsa_key.p8` using `openssl enc -d -base64 -in rsa_key.p8 | basenc --base64url -w0` (you can use `gbasenc` insted of `basenc` on OSX if you install `coreutils` via Homebrew). If you have a password-encrypted private key, you can decrypt it using `openssl pkcs8 -in rsa_key_encrypted.p8 -out rsa_key.p8`. Also, make sure fields such as the username are URL-encoded.
		dsn: string
		// The table to select from.
		table: string
		// A list of columns to select.
		columns: [...string]
		// An optional where clause to add. Placeholder arguments are populated with the `args_mapping` field. Placeholders should always be question marks, and will automatically be converted to dollar syntax when the postgres or clickhouse drivers are used.
		where?: string
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `where`.
		args_mapping?: string
		// An optional prefix to prepend to the select query (before SELECT).
		prefix?: string
		// An optional suffix to append to the select query.
		suffix?: string
		// An optional list of file paths containing SQL statements to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Glob patterns are supported, including super globs (double star).
		// 
		// Care should be taken to ensure that the statements are idempotent, and therefore would not cause issues when run multiple times after service restarts. If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If a statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_files?: [...string]
		// An optional SQL statement to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Care should be taken to ensure that the statement is idempotent, and therefore would not cause issues when run multiple times after service restarts.
		// 
		// If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If the statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_statement?: string
		// An optional maximum amount of time a connection may be idle. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's idle time.
		conn_max_idle_time?: string
		// An optional maximum amount of time a connection may be reused. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's age.
		conn_max_life_time?: string
		// An optional maximum number of connections in the idle connection pool. If conn_max_open is greater than 0 but less than the new conn_max_idle, then the new conn_max_idle will be reduced to match the conn_max_open limit. If value <= 0, no idle connections are retained. The default max idle connections is currently 2. This may change in a future release.
		conn_max_idle?: int
		// An optional maximum number of open connections to the database. If conn_max_idle is greater than 0 and the new conn_max_open is less than conn_max_idle, then conn_max_idle will be reduced to match the new conn_max_open limit. If value <= 0, then there is no limit on the number of open connections. The default is 0 (unlimited).
		conn_max_open?: int
	}
	// Consumes data piped to stdin as line delimited messages.
	stdin: {
		// The way in which the bytes of a data source should be converted into discrete messages, codecs are useful for specifying how large files or continuous streams of data might be processed in small chunks rather than loading it all in memory. It's possible to consume lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter. Codecs can be chained with `/`, for example a gzip compressed CSV file can be consumed with the codec `gzip/csv`.
		codec?: string
		// The maximum message buffer size. Must exceed the largest message to be consumed.
		max_buffer?: int
	}
	// Executes a command, runs it as a subprocess, and consumes messages from it over stdout.
	subprocess: {
		// The command to execute as a subprocess.
		name?: string
		// A list of arguments to provide the command.
		args?: [...string]
		// The way in which messages should be consumed from the subprocess.
		codec?: string
		// Whether the command should be re-executed each time the subprocess ends.
		restart_on_exit?: bool
		// The maximum expected size of an individual message.
		max_buffer?: int
	}
	// Consumes tweets matching a given search using the Twitter recent search V2 API.
	twitter_search: {
		// A search expression to use.
		query: string
		// An optional list of additional fields to obtain for each tweet, by default only the fields `id` and `text` are returned. For more info refer to the [twitter API docs.](https://developer.twitter.com/en/docs/twitter-api/fields)
		tweet_fields?: [...string]
		// The length of time (as a duration string) to wait between each search request. This field can be set empty, in which case requests are made at the limit set by the rate limit. This field also supports cron expressions.
		poll_period?: string
		// A duration string indicating the maximum age of tweets to acquire when starting a search.
		backfill_period?: string
		// A cache resource to use for request pagination.
		cache: string
		// The key identifier used when storing the ID of the last tweet received.
		cache_key?: string
		// An optional rate limit resource to restrict API requests with.
		rate_limit?: string
		// An API key for OAuth 2.0 authentication. It is recommended that you populate this field using [environment variables](/docs/configuration/interpolation).
		api_key: string
		// An API secret for OAuth 2.0 authentication. It is recommended that you populate this field using [environment variables](/docs/configuration/interpolation).
		api_secret: string
	}
	// Connects to a websocket server and continuously receives messages.
	websocket: {
		// The URL to connect to.
		url: string
		// An optional message to send to the server upon connection.
		open_message?: string
		// An optional flag to indicate the data type of open_message.
		open_message_type?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Customise how websocket connection attempts are made.
		connection?: {
			// An optional limit to the number of consecutive retry attempts that will be made before abandoning the connection altogether and gracefully terminating the input. When all inputs terminate in this way the service (or stream) will shut down. If set to zero connections will never be reattempted upon a failure. If set below zero this field is ignored (effectively unset).
			max_retries?: int
		}
		// Allows you to specify open authentication via OAuth version 1.
		oauth?: {
			// Whether to use OAuth version 1 in requests.
			enabled?: bool
			// A value used to identify the client to the service provider.
			consumer_key?: string
			// A secret used to establish ownership of the consumer key.
			consumer_secret?: string
			// A value used to gain access to the protected resources on behalf of the user.
			access_token?: string
			// A secret provided in order to establish ownership of a given access token.
			access_token_secret?: string
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// BETA: Allows you to specify JWT authentication.
		jwt?: {
			// Whether to use JWT authentication in requests.
			enabled?: bool
			// A file with the PEM encoded via PKCS1 or PKCS8 as private key.
			private_key_file?: string
			// A method used to sign the token such as RS256, RS384, RS512 or EdDSA.
			signing_method?: string
			// A value used to identify the claims that issued the JWT.
			claims?: {
				[string]: _
			}
			// Add optional key/value headers to the JWT.
			headers?: {
				[string]: _
			}
		}
	}
}
#Input: or([ for name, config in #AllInputs {
	(name): config
}])
#Input: {
	label?: string
}
#Input: {
	processors?: [...#Processor]
}
#AllOutputs: {
	// Sends messages to an AMQP (0.91) exchange. AMQP is a messaging protocol used by various message brokers, including RabbitMQ.Connects to an AMQP (0.91) queue. AMQP is a messaging protocol used by various message brokers, including RabbitMQ.
	amqp_0_9: {
		// A list of URLs to connect to. The first URL to successfully establish a connection will be used until the connection is closed. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// An AMQP exchange to publish to.
		exchange: string
		// Optionally declare the target exchange (passive).
		exchange_declare?: {
			// Whether to declare the exchange.
			enabled?: bool
			// The type of the exchange.
			type?: string
			// Whether the exchange should be durable.
			durable?: bool
		}
		// The binding key to set for each message.
		key?: string
		// The type property to set for each message.
		type?: string
		// The content type attribute to set for each message.
		content_type?: string
		// The content encoding attribute to set for each message.
		content_encoding?: string
		// Specify criteria for which metadata values are attached to messages as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
		// Set the priority of each message with a dynamic interpolated expression.
		priority?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Whether message delivery should be persistent (transient by default).
		persistent?: bool
		// Whether to set the mandatory flag on published messages. When set if a published message is routed to zero queues it is returned.
		mandatory?: bool
		// Whether to set the immediate flag on published messages. When set if there are no ready consumers of a queue then the message is dropped instead of waiting.
		immediate?: bool
		// The maximum period to wait before abandoning it and reattempting. If not set, wait indefinitely.
		timeout?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
	}
	// Sends messages to an AMQP (1.0) server.
	amqp_1: {
		// A URL to connect to.
		url: string
		// The target address to write to.
		target_address: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// An optional Bloblang mapping that can be defined in order to set the `application-properties` on output messages.
		application_properties_map?: string
		// Enables SASL authentication.
		sasl?: {
			// The SASL authentication mechanism to use.
			mechanism?: string
			// A SASL plain text username. It is recommended that you use environment variables to populate this field.
			user?: string
			// A SASL plain text password. It is recommended that you use environment variables to populate this field.
			password?: string
		}
		// Specify criteria for which metadata values are attached to messages as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
	}
	// Inserts items into a DynamoDB table.
	aws_dynamodb: {
		// The table to store messages in.
		table: string
		// A map of column keys to string values to store.
		string_columns?: {
			[string]: string
		}
		// A map of column keys to [field paths](/docs/configuration/field_paths) pointing to value data within messages.
		json_map_columns?: {
			[string]: string
		}
		// An optional TTL to set for items, calculated from the moment the message is sent.
		ttl?: string
		// The column key to place the TTL value within.
		ttl_key?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
	}
	// Sends messages to a Kinesis stream.
	aws_kinesis: {
		// The stream to publish messages to.
		stream: string
		// A required key for partitioning messages.
		partition_key: string
		// A optional hash key for partitioning messages.
		hash_key?: string
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
	}
	// Sends messages to a Kinesis Firehose delivery stream.
	aws_kinesis_firehose: {
		// The stream to publish messages to.
		stream: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
	}
	// Sends message parts as objects to an Amazon S3 bucket. Each object is uploaded with the path specified with the `path` field.
	aws_s3: {
		// The bucket to upload messages to.
		bucket: string
		// The path of each message to upload.
		path?: string
		// Key/value pairs to store with the object as tags.
		tags?: {
			[string]: string
		}
		// The content type to set for each object.
		content_type?: string
		// An optional content encoding to set for each object.
		content_encoding?: string
		// The cache control to set for each object.
		cache_control?: string
		// The content disposition to set for each object.
		content_disposition?: string
		// The content language to set for each object.
		content_language?: string
		// The website redirect location to set for each object.
		website_redirect_location?: string
		// Specify criteria for which metadata values are attached to objects as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
		// The storage class to set for each object.
		storage_class?: string
		// An optional server side encryption key.
		kms_key_id?: string
		// An optional server side encryption algorithm.
		server_side_encryption?: string
		// Forces the client API to use path style URLs, which helps when connecting to custom endpoints.
		force_path_style_urls?: bool
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// The maximum period to wait on an upload before abandoning it and reattempting.
		timeout?: string
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
	}
	// Sends messages to an AWS SNS topic.
	aws_sns: {
		// The topic to publish to.
		topic_arn: string
		// An optional group ID to set for messages.
		message_group_id?: string
		// An optional deduplication ID to set for messages.
		message_deduplication_id?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Specify criteria for which metadata values are sent as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
		// The maximum period to wait on an upload before abandoning it and reattempting.
		timeout?: string
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
	}
	// Sends messages to an SQS queue.
	aws_sqs: {
		// The URL of the target SQS queue.
		url: string
		// An optional group ID to set for messages.
		message_group_id?: string
		// An optional deduplication ID to set for messages.
		message_deduplication_id?: string
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// Specify criteria for which metadata values are sent as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
	}
	// Sends message parts as objects to an Azure Blob Storage Account container. Each object is uploaded with the filename specified with the `container` field.
	azure_blob_storage: {
		// The storage account to access. This field is ignored if `storage_connection_string` is set.
		storage_account?: string
		// The storage account access key. This field is ignored if `storage_connection_string` is set.
		storage_access_key?: string
		// The storage account SAS token. This field is ignored if `storage_connection_string` or `storage_access_key` are set.
		storage_sas_token?: string
		// A storage account connection string. This field is required if `storage_account` and `storage_access_key` / `storage_sas_token` are not set.
		storage_connection_string?: string
		// The container for uploading the messages to.
		container: string
		// The path of each message to upload.
		path?: string
		// Block and Append blobs are comprised of blocks, and each blob can support up to 50,000 blocks. The default value is `+"`BLOCK`"+`.`
		blob_type?: string
		// The container's public access level. The default value is `PRIVATE`.
		public_access_level?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
	}
	// Sends messages to an Azure Storage Queue.
	azure_queue_storage: {
		// The storage account to access. This field is ignored if `storage_connection_string` is set.
		storage_account?: string
		// The storage account access key. This field is ignored if `storage_connection_string` is set.
		storage_access_key?: string
		// A storage account connection string. This field is required if `storage_account` and `storage_access_key` / `storage_sas_token` are not set.
		storage_connection_string?: string
		// The name of the target Queue Storage queue.
		queue_name: string
		// The TTL of each individual message as a duration string. Defaults to 0, meaning no retention period is set
		ttl?: string
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Stores messages in an Azure Table Storage table.
	azure_table_storage: {
		// The storage account to access. This field is ignored if `storage_connection_string` is set.
		storage_account?: string
		// The storage account access key. This field is ignored if `storage_connection_string` is set.
		storage_access_key?: string
		// A storage account connection string. This field is required if `storage_account` and `storage_access_key` / `storage_sas_token` are not set.
		storage_connection_string?: string
		// The table to store messages into.
		table_name: string
		// The partition key.
		partition_key?: string
		// The row key.
		row_key?: string
		// A map of properties to store into the table.
		properties?: {
			[string]: string
		}
		// Type of insert operation. Valid options are `INSERT`, `INSERT_MERGE` and `INSERT_REPLACE`
		insert_type?: string
		// Type of transaction operation.
		transaction_type?: string
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// The maximum period to wait on an upload before abandoning it and reattempting.
		timeout?: string
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Write messages to a Beanstalkd queue.
	beanstalkd: {
		// An address to connect to.
		address: string
		// The maximum number of messages to have in flight at a given time. Increase to improve throughput.
		max_in_flight?: int
	}
	// Allows you to route messages to multiple child outputs using a range of
	// brokering [patterns](#patterns).
	broker: {
		// The number of copies of each configured output to spawn.
		copies?: int
		// The brokering pattern to use.
		pattern?: string
		// A list of child outputs to broker.
		outputs?: [...#Output]
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Stores each message in a [cache](/docs/components/caches/about).
	cache: {
		// The target cache to store messages in.
		target?: string
		// The key to store messages by, function interpolation should be used in order to derive a unique key for each message.
		key?: string
		// The TTL of each individual item as a duration string. After this period an item will be eligible for removal during the next compaction. Not all caches support per-key TTLs, and those that do not will fall back to their generally configured TTL setting.
		ttl?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
	}
	// Runs a query against a Cassandra database for each message in order to insert data.
	cassandra: {
		// A list of Cassandra nodes to connect to. Multiple comma separated addresses can be specified on a single line.
		addresses?: [...string]
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// An object containing the username and password.
		password_authenticator?: {
			// Whether to use password authentication.
			enabled?: bool
			// A username.
			username?: string
			// A password.
			password?: string
		}
		// If enabled the driver will not attempt to get host info from the system.peers table. This can speed up queries but will mean that data_centre, rack and token information will not be available.
		disable_initial_host_lookup?: bool
		// A query to execute for each message.
		query?: string
		// A [Bloblang mapping](/docs/guides/bloblang/about) that can be used to provide arguments to Cassandra queries. The result of the query must be an array containing a matching number of elements to the query arguments.
		args_mapping?: string
		// The consistency level to use.
		consistency?: string
		// If enabled the driver will perform a logged batch. Disabling this prompts unlogged batches to be used instead, which are less efficient but necessary for alternative storages that do not support logged batches.
		logged_batch?: bool
		// The maximum number of retries before giving up on a request.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?:     string
			max_elapsed_time?: string
		}
		// The client connection timeout.
		timeout?: string
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Writes messages to a Discord channel.
	discord: {
		// A discord channel ID to write messages to.
		channel_id: string
		// A bot token used for authentication.
		bot_token:   string
		rate_limit?: string
	}
	// Drops all messages.
	drop: {}
	// Attempts to write messages to a child output and if the write fails for one of a list of configurable reasons the message is dropped instead of being reattempted.
	drop_on: {
		// Whether messages should be dropped when the child output returns an error. For example, this could be when an http_client output gets a 4XX response code.
		error?: bool
		// An optional duration string that determines the maximum length of time to wait for a given message to be accepted by the child output before the message should be dropped instead. The most common reason for an output to block is when waiting for a lost connection to be re-established. Once a message has been dropped due to back pressure all subsequent messages are dropped immediately until the output is ready to process them again. Note that if `error` is set to `false` and this field is specified then messages dropped due to back pressure will return an error response.
		back_pressure?: string
		// A child output.
		output?: #Output
	}
	// A special broker type where the outputs are identified by unique labels and can be created, changed and removed during runtime via a REST API.
	dynamic: {
		// A map of outputs to statically create.
		outputs?: {
			[string]: #Output
		}
		// A path prefix for HTTP endpoints that are registered.
		prefix?: string
	}
	// Publishes messages into an Elasticsearch index. If the index does not exist then
	// it is created with a dynamic mapping.
	elasticsearch: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls?: [...string]
		// The index to place messages.
		index?: string
		// The action to take on the document. This field must resolve to one of the following action types: `create`, `index`, `update`, `upsert` or `delete`.
		action?: string
		// An optional pipeline id to preprocess incoming documents.
		pipeline?: string
		// The ID for indexed messages. Interpolation should be used in order to create a unique ID for each message.
		id?: string
		// The document mapping type. This field is required for versions of elasticsearch earlier than 6.0.0, but are invalid for versions 7.0.0 or later.
		type?: string
		// The routing key to use for the document.
		routing?: string
		// Prompts Benthos to sniff for brokers to connect to when establishing a connection.
		sniff?: bool
		// Whether to enable healthchecks.
		healthcheck?: bool
		// The maximum time to wait before abandoning a request (and trying again).
		timeout?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// Enables and customises connectivity to Amazon Elastic Service.
		aws?: {
			// Whether to connect to Amazon Elastic Service.
			enabled?: bool
			// The AWS region to target.
			region?: string
			// Allows you to specify a custom endpoint for the AWS API.
			endpoint?: string
			// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
			credentials?: {
				// A profile from `~/.aws/credentials` to use.
				profile?: string
				// The ID of credentials to use.
				id?: string
				// The secret for the credentials being used.
				secret?: string
				// The token for the credentials being used, required when using short term credentials.
				token?: string
				// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
				from_ec2_role?: bool
				// A role ARN to assume.
				role?: string
				// An external ID to provide when assuming a role.
				role_external_id?: string
			}
		}
		// Enable gzip compression on the request side.
		gzip_compression?: bool
	}
	// Attempts to send each message to a child output, starting from the first output on the list. If an output attempt fails then the next output in the list is attempted, and so on.
	fallback: [...#Output]
	// Writes messages to files on disk based on a chosen codec.
	file: {
		// The file to write to, if the file does not yet exist it will be created.
		path: string
		// The way in which the bytes of messages should be written out into the output data stream. It's possible to write lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter.
		codec?: string
	}
	// Sends messages as new rows to a Google Cloud BigQuery table.
	gcp_bigquery: {
		// The project ID of the dataset to insert data to. If not set, it will be inferred from the credentials or read from the GOOGLE_CLOUD_PROJECT environment variable.
		project?: string
		// The BigQuery Dataset ID.
		dataset: string
		// The table to insert messages to.
		table: string
		// The format of each incoming message.
		format?: string
		// The maximum number of message batches to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Specifies how existing data in a destination table is treated.
		write_disposition?: string
		// Specifies the circumstances under which destination table will be created. If CREATE_IF_NEEDED is used the GCP BigQuery will create the table if it does not already exist and tables are created atomically on successful completion of a job. The CREATE_NEVER option ensures the table must already exist and will not be automatically created.
		create_disposition?: string
		// Causes values not matching the schema to be tolerated. Unknown values are ignored. For CSV this ignores extra values at the end of a line. For JSON this ignores named values that do not match any column name. If this field is set to false (the default value), records containing unknown values are treated as bad records. The max_bad_records field can be used to customize how bad records are handled.
		ignore_unknown_values?: bool
		// The maximum number of bad records that will be ignored when reading data.
		max_bad_records?: int
		// Indicates if we should automatically infer the options and schema for CSV and JSON sources. If the table doesn't exist and this field is set to `false` the output may not be able to insert data and will throw insertion error. Be careful using this field since it delegates to the GCP BigQuery service the schema detection and values like `"no"` may be treated as booleans for the CSV format.
		auto_detect?: bool
		// A list of labels to add to the load job.
		job_labels?: {
			[string]: string
		}
		// Specify how CSV data should be interpretted.
		csv?: {
			// A list of values to use as header for each batch of messages. If not specified the first line of each message will be used as header.
			header?: [...string]
			// The separator for fields in a CSV file, used when reading or exporting data.
			field_delimiter?: string
			// Causes missing trailing optional columns to be tolerated when reading CSV data. Missing values are treated as nulls.
			allow_jagged_rows?: bool
			// Sets whether quoted data sections containing newlines are allowed when reading CSV data.
			allow_quoted_newlines?: bool
			// Encoding is the character encoding of data to be read.
			encoding?: string
			// The number of rows at the top of a CSV file that BigQuery will skip when reading data. The default value is 1 since Benthos will add the specified header in the first line of each batch sent to BigQuery.
			skip_leading_rows?: int
		}
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Sends message parts as objects to a Google Cloud Storage bucket. Each object is uploaded with the path specified with the `path` field.
	gcp_cloud_storage: {
		// The bucket to upload messages to.
		bucket: string
		// The path of each message to upload.
		path?: string
		// The content type to set for each object.
		content_type?: string
		// An optional content encoding to set for each object.
		content_encoding?: string
		// Determines how file path collisions should be dealt with.
		collision_mode?: string
		// An optional chunk size which controls the maximum number of bytes of the object that the Writer will attempt to send to the server in a single request. If ChunkSize is set to zero, chunking will be disabled.
		chunk_size?: int
		// The maximum period to wait on an upload before abandoning it and reattempting.
		timeout?: string
		// The maximum number of message batches to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Sends messages to a GCP Cloud Pub/Sub topic. [Metadata](/docs/configuration/metadata) from messages are sent as attributes.
	gcp_pubsub: {
		// The project ID of the topic to publish to.
		project: string
		// The topic to publish to.
		topic: string
		// An optional endpoint to override the default of `pubsub.googleapis.com:443`. This can be used to connect to a region specific pubsub endpoint. For a list of valid values check out [this document.](https://cloud.google.com/pubsub/docs/reference/service_apis_overview#list_of_regional_endpoints)
		endpoint?: string
		// The ordering key to use for publishing messages.
		ordering_key?: string
		// The maximum number of messages to have in flight at a given time. Increasing this may improve throughput.
		max_in_flight?: int
		// Publish a pubsub buffer when it has this many messages
		count_threshold?: int
		// Publish a non-empty pubsub buffer after this delay has passed.
		delay_threshold?: string
		// Publish a batch when its size in bytes reaches this value.
		byte_threshold?: int
		// The maximum length of time to wait before abandoning a publish attempt for a message.
		publish_timeout?: string
		// Specify criteria for which metadata values are sent as attributes, all are sent by default.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
		// For a given topic, configures the PubSub client's internal buffer for messages to be published.
		flow_control?: {
			// Maximum size of buffered messages to be published. If less than or equal to zero, this is disabled.
			max_outstanding_bytes?: int
			// Maximum number of buffered messages to be published. If less than or equal to zero, this is disabled.
			max_outstanding_messages?: int
			// Configures the behavior when trying to publish additional messages while the flow controller is full. The available options are block (default), ignore (disable), and signal_error (publish results will return an error).
			limit_exceeded_behavior?: string
		}
		// Configures a batching policy on this output. While the PubSub client maintains its own internal buffering mechanism, preparing larger batches of messages can futher trade-off some latency for throughput.
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Sends message parts as files to a HDFS directory.
	hdfs: {
		// A list of target host addresses to connect to.
		hosts: [...string]
		// A user ID to connect as.
		user?: string
		// A directory to store message files within. If the directory does not exist it will be created.
		directory: string
		// The path to upload messages as, interpolation functions should be used in order to generate unique file paths.
		path?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Sends messages to an HTTP server.
	http_client: {
		// The URL to connect to.
		url: string
		// A verb to connect with
		verb?: string
		// A map of headers to add to the request.
		headers?: {
			[string]: string
		}
		// Specify optional matching rules to determine which metadata keys should be added to the HTTP request as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to match against.
			include_prefixes?: [...string]
			// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
			include_patterns?: [...string]
		}
		// EXPERIMENTAL: Optionally set a level at which the request and response payload of each request made will be logged.
		dump_request_log_level?: string
		// Allows you to specify open authentication via OAuth version 1.
		oauth?: {
			// Whether to use OAuth version 1 in requests.
			enabled?: bool
			// A value used to identify the client to the service provider.
			consumer_key?: string
			// A secret used to establish ownership of the consumer key.
			consumer_secret?: string
			// A value used to gain access to the protected resources on behalf of the user.
			access_token?: string
			// A secret provided in order to establish ownership of a given access token.
			access_token_secret?: string
		}
		// Allows you to specify open authentication via OAuth version 2 using the client credentials token flow.
		oauth2?: {
			// Whether to use OAuth version 2 in requests.
			enabled?: bool
			// A value used to identify the client to the token provider.
			client_key?: string
			// A secret used to establish ownership of the client key.
			client_secret?: string
			// The URL of the token provider.
			token_url?: string
			// A list of optional requested permissions.
			scopes?: [...string]
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// BETA: Allows you to specify JWT authentication.
		jwt?: {
			// Whether to use JWT authentication in requests.
			enabled?: bool
			// A file with the PEM encoded via PKCS1 or PKCS8 as private key.
			private_key_file?: string
			// A method used to sign the token such as RS256, RS384, RS512 or EdDSA.
			signing_method?: string
			// A value used to identify the claims that issued the JWT.
			claims?: {
				[string]: _
			}
			// Add optional key/value headers to the JWT.
			headers?: {
				[string]: _
			}
		}
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Specify which response headers should be added to resulting synchronous response messages as metadata. Header keys are lowercased before matching, so ensure that your patterns target lowercased versions of the header keys that you expect. This field is not applicable unless `propagate_response` is set to `true`.
		extract_headers?: {
			// Provide a list of explicit metadata key prefixes to match against.
			include_prefixes?: [...string]
			// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
			include_patterns?: [...string]
		}
		// An optional [rate limit](/docs/components/rate_limits/about) to throttle requests by.
		rate_limit?: string
		// A static timeout to apply to requests.
		timeout?: string
		// The base period to wait between failed requests.
		retry_period?: string
		// The maximum period to wait between failed requests.
		max_retry_backoff?: string
		// The maximum number of retry attempts to make.
		retries?: int
		// A list of status codes whereby the request should be considered to have failed and retries should be attempted, but the period between them should be increased gradually.
		backoff_on?: [...int]
		// A list of status codes whereby the request should be considered to have failed but retries should not be attempted. This is useful for preventing wasted retries for requests that will never succeed. Note that with these status codes the _request_ is dropped, but _message_ that caused the request will not be dropped.
		drop_on?: [...int]
		// A list of status codes whereby the attempt should be considered successful, this is useful for dropping requests that return non-2XX codes indicating that the message has been dealt with, such as a 303 See Other or a 409 Conflict. All 2XX codes are considered successful unless they are present within `backoff_on` or `drop_on`, regardless of this field.
		successful_on?: [...int]
		// An optional HTTP proxy URL.
		proxy_url?: string
		// Send message batches as a single request using [RFC1341](https://www.w3.org/Protocols/rfc1341/7_2_Multipart.html). If disabled messages in batches will be sent as individual requests.
		batch_as_multipart?: bool
		// Whether responses from the server should be [propagated back](/docs/guides/sync_responses) to the input.
		propagate_response?: bool
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// EXPERIMENTAL: Create explicit multipart HTTP requests by specifying an array of parts to add to the request, each part specified consists of content headers and a data field that can be populated dynamically. If this field is populated it will override the default request creation behaviour.
		multipart?: [...{
			// The content type of the individual message part.
			content_type?: string
			// The content disposition of the individual message part.
			content_disposition?: string
			// The body of the individual message part.
			body?: string
		}]
	}
	// Sets up an HTTP server that will send messages over HTTP(S) GET requests. HTTP 2.0 is supported when using TLS, which is enabled when key and cert files are specified.
	http_server: {
		// An alternative address to host from. If left empty the service wide address is used.
		address?: string
		// The path from which discrete messages can be consumed.
		path?: string
		// The path from which a continuous stream of messages can be consumed.
		stream_path?: string
		// The path from which websocket connections can be established.
		ws_path?: string
		// An array of verbs that are allowed for the `path` and `stream_path` HTTP endpoint.
		allowed_verbs?: [...string]
		// The maximum time to wait before a blocking, inactive connection is dropped (only applies to the `path` endpoint).
		timeout?: string
		// Enable TLS by specifying a certificate and key file. Only valid with a custom `address`.
		cert_file?: string
		// Enable TLS by specifying a certificate and key file. Only valid with a custom `address`.
		key_file?: string
		// Adds Cross-Origin Resource Sharing headers. Only valid with a custom `address`.
		cors?: {
			// Whether to allow CORS requests.
			enabled?: bool
			// An explicit list of origins that are allowed for CORS requests.
			allowed_origins?: [...string]
		}
	}
	inproc: string
	// The kafka output type writes a batch of messages to Kafka brokers and waits for acknowledgement before propagating it back to the input.
	kafka: {
		// A list of broker addresses to connect to. If an item of the list contains commas it will be expanded into multiple addresses.
		addresses?: [...string]
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Enables SASL authentication.
		sasl?: {
			// The SASL authentication mechanism, if left empty SASL authentication is not used. Warning: SCRAM based methods within Benthos have not received a security audit.
			mechanism?: string
			// A PLAIN username. It is recommended that you use environment variables to populate this field.
			user?: string
			// A PLAIN password. It is recommended that you use environment variables to populate this field.
			password?: string
			// A static OAUTHBEARER access token
			access_token?: string
			// Instead of using a static `access_token` allows you to query a [`cache`](/docs/components/caches/about) resource to fetch OAUTHBEARER tokens from
			token_cache?: string
			// Required when using a `token_cache`, the key to query the cache with for tokens.
			token_key?: string
		}
		// The topic to publish messages to.
		topic?: string
		// An identifier for the client connection.
		client_id?: string
		// The version of the Kafka protocol to use. This limits the capabilities used by the client and should ideally match the version of your brokers.
		target_version?: string
		// A rack identifier for this client.
		rack_id?: string
		// The key to publish messages with.
		key?: string
		// The partitioning algorithm to use.
		partitioner?: string
		// The manually-specified partition to publish messages to, relevant only when the field `partitioner` is set to `manual`. Must be able to parse as a 32-bit integer.
		partition?: string
		// The compression algorithm to use.
		compression?: string
		// An optional map of static headers that should be added to messages in addition to metadata.
		static_headers?: {
			[string]: string
		}
		// Specify criteria for which metadata values are sent with messages as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
		// EXPERIMENTAL: A [Bloblang mapping](/docs/guides/bloblang/about) used to inject an object containing tracing propagation information into outbound messages. The specification of the injected fields will match the format used by the service wide tracer.
		inject_tracing_map?: string
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// Ensure that messages have been copied across all replicas before acknowledging receipt.
		ack_replicas?: bool
		// The maximum size in bytes of messages sent to the target topic.
		max_msg_bytes?: int
		// The maximum period of time to wait for message sends before abandoning the request and retrying.
		timeout?: string
		// When enabled forces an entire batch of messages to be retried if any individual message fails on a send, otherwise only the individual messages that failed are retried. Disabling this helps to reduce message duplicates during intermittent errors, but also makes it impossible to guarantee strict ordering of messages.
		retry_as_batch?: bool
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
	}
	// A Kafka output using the [Franz Kafka client library](https://github.com/twmb/franz-go).
	kafka_franz: {
		// A list of broker addresses to connect to in order to establish connections. If an item of the list contains commas it will be expanded into multiple addresses.
		seed_brokers: [...string]
		// A topic to write messages to.
		topic: string
		// An optional key to populate for each message.
		key?: string
		// Override the default murmur2 hashing partitioner.
		partitioner?: string
		// An optional explicit partition to set for each message. This field is only relevant when the `partitioner` is set to `manual`. The provided interpolation string must be a valid integer.
		partition?: string
		// Determine which (if any) metadata values should be added to messages as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to match against.
			include_prefixes?: [...string]
			// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
			include_patterns?: [...string]
		}
		// The maximum number of batches to be sending in parallel at any given time.
		max_in_flight?: int
		// The maximum period of time to wait for message sends before abandoning the request and retrying
		timeout?: string
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The maximum space in bytes than an individual message may take, messages larger than this value will be rejected. This field corresponds to Kafka's `max.message.bytes`.
		max_message_bytes?: string
		// Optionally set an explicit compression type. The default preference is to use snappy when the broker supports it, and fall back to none if not.
		compression?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Specify one or more methods of SASL authentication. SASL is tried in order; if the broker supports the first mechanism, all connections will use that mechanism. If the first mechanism fails, the client will pick the first supported mechanism. If the broker does not support any client mechanisms, connections will fail.
		sasl?: [...{
			// The SASL mechanism to use.
			mechanism: string
			// A username to provide for PLAIN or SCRAM-* authentication.
			username?: string
			// A password to provide for PLAIN or SCRAM-* authentication.
			password?: string
			// The token to use for a single session's OAUTHBEARER authentication.
			token?: string
			// Key/value pairs to add to OAUTHBEARER authentication requests.
			extensions?: {
				[string]: string
			}
			// Contains AWS specific fields for when the `mechanism` is set to `AWS_MSK_IAM`.
			aws?: {
				// The AWS region to target.
				region?: string
				// Allows you to specify a custom endpoint for the AWS API.
				endpoint?: string
				// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
				credentials?: {
					// A profile from `~/.aws/credentials` to use.
					profile?: string
					// The ID of credentials to use.
					id?: string
					// The secret for the credentials being used.
					secret?: string
					// The token for the credentials being used, required when using short term credentials.
					token?: string
					// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
					from_ec2_role?: bool
					// A role ARN to assume.
					role?: string
					// An external ID to provide when assuming a role.
					role_external_id?: string
				}
			}
		}]
	}
	// Inserts items into a MongoDB collection.
	mongodb: {
		// The URL of the target MongoDB server.
		url: string
		// The name of the target MongoDB database.
		database: string
		// The username to connect to the database.
		username?: string
		// The password to connect to the database.
		password?: string
		// The name of the target collection.
		collection: string
		// The mongodb operation to perform.
		operation?: string
		// The write concern settings for the mongo connection.
		write_concern?: {
			// W requests acknowledgement that write operations propagate to the specified number of mongodb instances.
			w?: string
			// J requests acknowledgement from MongoDB that write operations are written to the journal.
			j?: bool
			// The write concern timeout.
			w_timeout?: string
		}
		// A bloblang map representing the records in the mongo db. Used to generate the document for mongodb by mapping the fields in the message to the mongodb fields. The document map is required for the operations insert-one, replace-one and update-one.
		document_map?: string
		// A bloblang map representing the filter for the mongo db command. The filter map is required for all operations except insert-one. It is used to find the document(s) for the operation. For example in a delete-one case, the filter map should have the fields required to locate the document to delete.
		filter_map?: string
		// A bloblang map representing the hint for the mongo db command. This map is optional and is used with all operations except insert-one. It is used to improve performance of finding the documents in the mongodb.
		hint_map?: string
		// The upsert setting is optional and only applies for update-one and replace-one operations. If the filter specified in filter_map matches, the document is updated or replaced accordingly, otherwise it is created.
		upsert?: bool
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
	}
	// Pushes messages to an MQTT broker.
	mqtt: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls?: [...string]
		// The topic to publish messages to.
		topic?: string
		// An identifier for the client connection.
		client_id?: string
		// Append a dynamically generated suffix to the specified `client_id` on each run of the pipeline. This can be useful when clustering Benthos producers.
		dynamic_client_id_suffix?: string
		// The QoS value to set for each message.
		qos?: int
		// The maximum amount of time to wait in order to establish a connection before the attempt is abandoned.
		connect_timeout?: string
		// The maximum amount of time to wait to write data before the attempt is abandoned.
		write_timeout?: string
		// Set message as retained on the topic.
		retained?: bool
		// Override the value of `retained` with an interpolable value, this allows it to be dynamically set based on message contents. The value must resolve to either `true` or `false`.
		retained_interpolated?: string
		// Set last will message in case of Benthos failure
		will?: {
			// Whether to enable last will messages.
			enabled?: bool
			// Set QoS for last will message.
			qos?: int
			// Set retained for last will message.
			retained?: bool
			// Set topic for last will message.
			topic?: string
			// Set payload for last will message.
			payload?: string
		}
		// A username to connect with.
		user?: string
		// A password to connect with.
		password?: string
		// Max seconds of inactivity before a keepalive message is sent.
		keepalive?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
	}
	// Send messages over a Nanomsg socket.
	nanomsg: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls?: [...string]
		// Whether the URLs listed should be bind (otherwise they are connected to).
		bind?: bool
		// The socket type to send with.
		socket_type?: string
		// The maximum period of time to wait for a message to send before the request is abandoned and reattempted.
		poll_timeout?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
	}
	// Publish to an NATS subject.
	nats: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// The subject to publish to.
		subject: string
		// Explicit message headers to add to messages.
		headers?: {
			[string]: string
		}
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Write messages to a NATS JetStream subject.
	nats_jetstream: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// A subject to write to.
		subject: string
		// Explicit message headers to add to messages.
		headers?: {
			[string]: string
		}
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Put messages in a NATS key-value bucket.
	nats_kv: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// The name of the KV bucket to operate on.
		bucket: string
		// The key for each message.
		key: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Publish to a NATS Stream subject.
	nats_stream: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// The cluster ID to publish to.
		cluster_id: string
		// The subject to publish to.
		subject: string
		// The client ID to connect with.
		client_id?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Publish to an NSQ topic.
	nsq: {
		// The address of the target NSQD server.
		nsqd_tcp_address?: string
		// The topic to publish to.
		topic?: string
		// A user agent string to connect with.
		user_agent?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
	}
	// Write messages to an Apache Pulsar server.
	pulsar: {
		// A URL to connect to.
		url: string
		// The topic to publish to.
		topic: string
		// Specify the path to a custom CA certificate to trust broker TLS service.
		tls?: {
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
		}
		// The key to publish messages with.
		key?: string
		// The ordering key to publish messages with.
		ordering_key?: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Optional configuration of Pulsar authentication methods.
		auth?: {
			// Parameters for Pulsar OAuth2 authentication.
			oauth2?: {
				// Whether OAuth2 is enabled.
				enabled?: bool
				// OAuth2 audience.
				audience?: string
				// OAuth2 issuer URL.
				issuer_url?: string
				// The path to a file containing a private key.
				private_key_file?: string
			}
			// Parameters for Pulsar Token authentication.
			token?: {
				// Whether Token Auth is enabled.
				enabled?: bool
				// Actual base64 encoded token.
				token?: string
			}
		}
	}
	// Output for publishing messages to Pusher API (https://pusher.com)
	pusher: {
		// maximum batch size is 10 (limit of the pusher library)
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// Pusher channel to publish to. Interpolation functions can also be used
		channel: string
		// Event to publish to
		event: string
		// Pusher app id
		appId: string
		// Pusher key
		key: string
		// Pusher secret
		secret: string
		// Pusher cluster
		cluster: string
		// Enable SSL encryption
		secure?: bool
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
	}
	// Sets Redis hash objects using the HMSET command.
	redis_hash: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The key for each message, function interpolations should be used to create a unique key per message.
		key: string
		// Whether all metadata fields of messages should be walked and added to the list of hash fields to set.
		walk_metadata?: bool
		// Whether to walk each message as a JSON object and add each key/value pair to the list of hash fields to set.
		walk_json_object?: bool
		// A map of key/value pairs to set as hash fields.
		fields?: {
			[string]: string
		}
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
	}
	// Pushes messages onto the end of a Redis list (which is created if it doesn't already exist) using the RPUSH command.
	redis_list: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The key for each message, function interpolations can be optionally used to create a unique key per message.
		key: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Publishes messages through the Redis PubSub model. It is not possible to guarantee that messages have been received.
	redis_pubsub: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The channel to publish messages to.
		channel: string
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Pushes messages to a Redis (v5.0+) Stream (which is created if it doesn't already exist) using the XADD command.
	redis_streams: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The stream to add messages to.
		stream: string
		// A key to set the raw body of the message to.
		body_key?: string
		// When greater than zero enforces a rough cap on the length of the target stream.
		max_length?: int
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
		// Specify criteria for which metadata values are included in the message body.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to be excluded when adding metadata to sent messages.
			exclude_prefixes?: [...string]
		}
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Rejects all messages, treating them as though the output destination failed to publish them.
	reject: string
	// Resource is an output type that channels messages to a resource output, identified by its name.
	resource: string
	// Attempts to write messages to a child output and if the write fails for any
	// reason the message is retried either until success or, if the retries or max
	// elapsed time fields are non-zero, either is reached.
	retry: {
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
		// A child output.
		output?: #Output
	}
	// Writes files to a server over SFTP.
	sftp: {
		// The address of the server to connect to that has the target files.
		address?: string
		// The file to save the messages to on the server.
		path?: string
		// The way in which the bytes of messages should be written out into the output data stream. It's possible to write lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter.
		codec?: string
		// The credentials to use to log into the server.
		credentials?: {
			// The username to connect to the SFTP server.
			username?: string
			// The password for the username to connect to the SFTP server.
			password?: string
			// The private key for the username to connect to the SFTP server.
			private_key_file?: string
			// Optional passphrase for private key.
			private_key_pass?: string
		}
		// The maximum number of messages to have in flight at a given time. Increase this to improve throughput.
		max_in_flight?: int
	}
	// Sends messages to Snowflake stages and, optionally, calls Snowpipe to load this data into one or more tables.
	snowflake_put: {
		// Account name, which is the same as the Account Identifier
		// as described [here](https://docs.snowflake.com/en/user-guide/admin-account-identifier.html#where-are-account-identifiers-used).
		// However, when using an [Account Locator](https://docs.snowflake.com/en/user-guide/admin-account-identifier.html#using-an-account-locator-as-an-identifier),
		// the Account Identifier is formatted as `<account_locator>.<region_id>.<cloud>` and this field needs to be
		// populated using the `<account_locator>` part.
		account: string
		// Optional region field which needs to be populated when using
		// an [Account Locator](https://docs.snowflake.com/en/user-guide/admin-account-identifier.html#using-an-account-locator-as-an-identifier)
		// and it must be set to the `<region_id>` part of the Account Identifier
		// (`<account_locator>.<region_id>.<cloud>`).
		region?: string
		// Optional cloud platform field which needs to be populated
		// when using an [Account Locator](https://docs.snowflake.com/en/user-guide/admin-account-identifier.html#using-an-account-locator-as-an-identifier)
		// and it must be set to the `<cloud>` part of the Account Identifier
		// (`<account_locator>.<region_id>.<cloud>`).
		cloud?: string
		// Username.
		user: string
		// An optional password.
		password?: string
		// The path to a file containing the private SSH key.
		private_key_file?: string
		// An optional private SSH key passphrase.
		private_key_pass?: string
		// Role.
		role: string
		// Database.
		database: string
		// Warehouse.
		warehouse: string
		// Schema.
		schema: string
		// Stage name. Use either one of the
		// [supported](https://docs.snowflake.com/en/user-guide/data-load-local-file-system-create-stage.html) stage types.
		stage: string
		// Stage path.
		path?: string
		// Stage file name. Will be equal to the Request ID if not set or empty.
		file_name?: string
		// Stage file extension. Will be derived from the configured `compression` if not set or empty.
		file_extension?: string
		// Specifies the number of threads to use for uploading files.
		upload_parallel_threads?: int
		// Compression type.
		compression?: string
		// Request ID. Will be assigned a random UUID (v4) string if not set or empty.
		request_id?: string
		// An optional Snowpipe name. Use the `<snowpipe>` part from `<database>.<schema>.<snowpipe>`.
		snowpipe?: string
		// Enable Snowflake keepalive mechanism to prevent the client session from expiring after 4 hours (error 390114).
		client_session_keep_alive?: bool
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
	}
	// Connects to a (tcp/udp/unix) server and sends a continuous stream of data, dividing messages according to the specified codec.
	socket: {
		// The network type to connect as.
		network?: string
		// The address (or path) to connect to.
		address?: string
		// The way in which the bytes of messages should be written out into the output data stream. It's possible to write lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter.
		codec?: string
	}
	// Writes messages to a Splunk HTTP Endpoint Collector.
	splunk_hec: {
		// Full HTTP Endpoint Collector (HEC) URL, ie. https://foobar.splunkcloud.com/services/collector/event
		url: string
		// A bot token used for authentication.
		token: string
		// Enable gzip compression
		gzip?: bool
		// Set the host value to assign to the event data. Overrides existing host field if present.
		event_host?: string
		// Set the source value to assign to the event data. Overrides existing source field if present.
		event_source?: string
		// Set the sourcetype value to assign to the event data. Overrides existing sourcetype field if present.
		event_sourcetype?: string
		// Set the index value to assign to the event data. Overrides existing index field if present.
		event_index?: string
		// A number of messages at which the batch should be flushed. If 0 disables count based batching.
		batching_count?: int
		// A period in which an incomplete batch should be flushed regardless of its size.
		batching_period?: string
		// An amount of bytes at which the batch should be flushed. If 0 disables size based batching. Splunk Cloud recommends limiting content length of HEC payload to 1 MB.
		batching_byte_size?: int
		// An optional rate limit resource to restrict API requests with.
		rate_limit?: string
		// The maximum number of parallel message batches to have in flight at any given time.
		max_in_flight?: int
		// Whether to skip server side certificate verification.
		skip_cert_verify?: bool
	}
	// Executes an arbitrary SQL query for each message.
	sql: {
		// A database [driver](#drivers) to use.
		driver: string
		// Data source name.
		data_source_name: string
		// The query to execute. The style of placeholder to use depends on the driver, some drivers require question marks (`?`) whereas others expect incrementing dollar signs (`$1`, `$2`, and so on). The style to use is outlined in this table:
		// 
		// | Driver | Placeholder Style |
		// |---|---|
		// | `clickhouse` | Dollar sign |
		// | `mysql` | Question mark |
		// | `postgres` | Dollar sign |
		// | `mssql` | Question mark |
		// | `sqlite` | Question mark |
		// | `oracle` | Colon |
		// | `snowflake` | Question mark |
		// | `trino` | Question mark |
		query: string
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `query`.
		args_mapping?: string
		// The maximum number of inserts to run in parallel.
		max_in_flight?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Inserts a row into an SQL database for each message.
	sql_insert: {
		// A database [driver](#drivers) to use.
		driver: string
		// A Data Source Name to identify the target database.
		// 
		// #### Drivers
		// 
		// The following is a list of supported drivers, their placeholder style, and their respective DSN formats:
		// 
		// | Driver | Data Source Name Format |
		// |---|---|
		// | `clickhouse` | [`clickhouse://[username[:password]@][netloc][:port]/dbname[?param1=value1&...&paramN=valueN]`](https://github.com/ClickHouse/clickhouse-go#dsn) |
		// | `mysql` | `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]` |
		// | `postgres` | `postgres://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]` |
		// | `mssql` | `sqlserver://[user[:password]@][netloc][:port][?database=dbname&param1=value1&...]` |
		// | `sqlite` | `file:/path/to/filename.db[?param&=value1&...]` |
		// | `oracle` | `oracle://[username[:password]@][netloc][:port]/service_name?server=server2&server=server3` |
		// | `snowflake` | `username[:password]@account_identifier/dbname/schemaname[?param1=value&...&paramN=valueN]` |
		// | `trino` | [`http[s]://user[:pass]@host[:port][?parameters]`](https://github.com/trinodb/trino-go-client#dsn-data-source-name)
		// 
		// Please note that the `postgres` driver enforces SSL by default, you can override this with the parameter `sslmode=disable` if required.
		// 
		// The `snowflake` driver supports multiple DSN formats. Please consult [the docs](https://pkg.go.dev/github.com/snowflakedb/gosnowflake#hdr-Connection_String) for more details. For [key pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth.html#configuring-key-pair-authentication), the DSN has the following format: `<snowflake_user>@<snowflake_account>/<db_name>/<schema_name>?warehouse=<warehouse>&role=<role>&authenticator=snowflake_jwt&privateKey=<base64_url_encoded_private_key>`, where the value for the `privateKey` parameter can be constructed from an unencrypted RSA private key file `rsa_key.p8` using `openssl enc -d -base64 -in rsa_key.p8 | basenc --base64url -w0` (you can use `gbasenc` insted of `basenc` on OSX if you install `coreutils` via Homebrew). If you have a password-encrypted private key, you can decrypt it using `openssl pkcs8 -in rsa_key_encrypted.p8 -out rsa_key.p8`. Also, make sure fields such as the username are URL-encoded.
		dsn: string
		// The table to insert to.
		table: string
		// A list of columns to insert.
		columns: [...string]
		// A [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of columns specified.
		args_mapping: string
		// An optional prefix to prepend to the insert query (before INSERT).
		prefix?: string
		// An optional suffix to append to the insert query.
		suffix?: string
		// The maximum number of inserts to run in parallel.
		max_in_flight?: int
		// An optional list of file paths containing SQL statements to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Glob patterns are supported, including super globs (double star).
		// 
		// Care should be taken to ensure that the statements are idempotent, and therefore would not cause issues when run multiple times after service restarts. If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If a statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_files?: [...string]
		// An optional SQL statement to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Care should be taken to ensure that the statement is idempotent, and therefore would not cause issues when run multiple times after service restarts.
		// 
		// If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If the statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_statement?: string
		// An optional maximum amount of time a connection may be idle. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's idle time.
		conn_max_idle_time?: string
		// An optional maximum amount of time a connection may be reused. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's age.
		conn_max_life_time?: string
		// An optional maximum number of connections in the idle connection pool. If conn_max_open is greater than 0 but less than the new conn_max_idle, then the new conn_max_idle will be reduced to match the conn_max_open limit. If value <= 0, no idle connections are retained. The default max idle connections is currently 2. This may change in a future release.
		conn_max_idle?: int
		// An optional maximum number of open connections to the database. If conn_max_idle is greater than 0 and the new conn_max_open is less than conn_max_idle, then conn_max_idle will be reduced to match the new conn_max_open limit. If value <= 0, then there is no limit on the number of open connections. The default is 0 (unlimited).
		conn_max_open?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Executes an arbitrary SQL query for each message.
	sql_raw: {
		// A database [driver](#drivers) to use.
		driver: string
		// A Data Source Name to identify the target database.
		// 
		// #### Drivers
		// 
		// The following is a list of supported drivers, their placeholder style, and their respective DSN formats:
		// 
		// | Driver | Data Source Name Format |
		// |---|---|
		// | `clickhouse` | [`clickhouse://[username[:password]@][netloc][:port]/dbname[?param1=value1&...&paramN=valueN]`](https://github.com/ClickHouse/clickhouse-go#dsn) |
		// | `mysql` | `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]` |
		// | `postgres` | `postgres://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]` |
		// | `mssql` | `sqlserver://[user[:password]@][netloc][:port][?database=dbname&param1=value1&...]` |
		// | `sqlite` | `file:/path/to/filename.db[?param&=value1&...]` |
		// | `oracle` | `oracle://[username[:password]@][netloc][:port]/service_name?server=server2&server=server3` |
		// | `snowflake` | `username[:password]@account_identifier/dbname/schemaname[?param1=value&...&paramN=valueN]` |
		// | `trino` | [`http[s]://user[:pass]@host[:port][?parameters]`](https://github.com/trinodb/trino-go-client#dsn-data-source-name)
		// 
		// Please note that the `postgres` driver enforces SSL by default, you can override this with the parameter `sslmode=disable` if required.
		// 
		// The `snowflake` driver supports multiple DSN formats. Please consult [the docs](https://pkg.go.dev/github.com/snowflakedb/gosnowflake#hdr-Connection_String) for more details. For [key pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth.html#configuring-key-pair-authentication), the DSN has the following format: `<snowflake_user>@<snowflake_account>/<db_name>/<schema_name>?warehouse=<warehouse>&role=<role>&authenticator=snowflake_jwt&privateKey=<base64_url_encoded_private_key>`, where the value for the `privateKey` parameter can be constructed from an unencrypted RSA private key file `rsa_key.p8` using `openssl enc -d -base64 -in rsa_key.p8 | basenc --base64url -w0` (you can use `gbasenc` insted of `basenc` on OSX if you install `coreutils` via Homebrew). If you have a password-encrypted private key, you can decrypt it using `openssl pkcs8 -in rsa_key_encrypted.p8 -out rsa_key.p8`. Also, make sure fields such as the username are URL-encoded.
		dsn: string
		// The query to execute. The style of placeholder to use depends on the driver, some drivers require question marks (`?`) whereas others expect incrementing dollar signs (`$1`, `$2`, and so on). The style to use is outlined in this table:
		// 
		// | Driver | Placeholder Style |
		// |---|---|
		// | `clickhouse` | Dollar sign |
		// | `mysql` | Question mark |
		// | `postgres` | Dollar sign |
		// | `mssql` | Question mark |
		// | `sqlite` | Question mark |
		// | `oracle` | Colon |
		// | `snowflake` | Question mark |
		// | `trino` | Question mark |
		query: string
		// Whether to enable [interpolation functions](/docs/configuration/interpolation/#bloblang-queries) in the query. Great care should be made to ensure your queries are defended against injection attacks.
		unsafe_dynamic_query?: bool
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `query`.
		args_mapping?: string
		// The maximum number of inserts to run in parallel.
		max_in_flight?: int
		// An optional list of file paths containing SQL statements to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Glob patterns are supported, including super globs (double star).
		// 
		// Care should be taken to ensure that the statements are idempotent, and therefore would not cause issues when run multiple times after service restarts. If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If a statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_files?: [...string]
		// An optional SQL statement to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Care should be taken to ensure that the statement is idempotent, and therefore would not cause issues when run multiple times after service restarts.
		// 
		// If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If the statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_statement?: string
		// An optional maximum amount of time a connection may be idle. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's idle time.
		conn_max_idle_time?: string
		// An optional maximum amount of time a connection may be reused. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's age.
		conn_max_life_time?: string
		// An optional maximum number of connections in the idle connection pool. If conn_max_open is greater than 0 but less than the new conn_max_idle, then the new conn_max_idle will be reduced to match the conn_max_open limit. If value <= 0, no idle connections are retained. The default max idle connections is currently 2. This may change in a future release.
		conn_max_idle?: int
		// An optional maximum number of open connections to the database. If conn_max_idle is greater than 0 and the new conn_max_open is less than conn_max_idle, then conn_max_idle will be reduced to match the new conn_max_open limit. If value <= 0, then there is no limit on the number of open connections. The default is 0 (unlimited).
		conn_max_open?: int
		// Allows you to configure a [batching policy](/docs/configuration/batching).
		batching?: {
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Prints messages to stdout as a continuous stream of data, dividing messages according to the specified codec.
	stdout: {
		// The way in which the bytes of messages should be written out into the output data stream. It's possible to write lines using a custom delimiter with the `delim:x` codec, where x is the character sequence custom delimiter.
		codec?: string
	}
	// Executes a command, runs it as a subprocess, and writes messages to it over stdin.
	subprocess: {
		// The command to execute as a subprocess.
		name?: string
		// A list of arguments to provide the command.
		args?: [...string]
		// The way in which messages should be written to the subprocess.
		codec?: string
	}
	// The switch output type allows you to route messages to different outputs based on their contents.
	switch: {
		// If a selected output fails to send a message this field determines whether it is
		// reattempted indefinitely. If set to false the error is instead propagated back
		// to the input level.
		// 
		// If a message can be routed to >1 outputs it is usually best to set this to true
		// in order to avoid duplicate messages being routed to an output.
		retry_until_success?: bool
		// This field determines whether an error should be reported if no condition is met.
		// If set to true, an error is propagated back to the input level. The default
		// behavior is false, which will drop the message.
		strict_mode?: bool
		// A list of switch cases, outlining outputs that can be routed to.
		cases?: [...{
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should be routed to the case output. If left empty the case always passes.
			check?: string
			// An [output](/docs/components/outputs/about/) for messages that pass the check to be routed to.
			output?: #Output
			// Indicates whether, if this case passes for a message, the next case should also be tested.
			continue?: bool
		}]
	}
	// Returns the final message payload back to the input origin of the message, where
	// it is dealt with according to that specific input type.
	sync_response: {}
	// Sends messages to an HTTP server via a websocket connection.
	websocket: {
		// The URL to connect to.
		url: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Allows you to specify open authentication via OAuth version 1.
		oauth?: {
			// Whether to use OAuth version 1 in requests.
			enabled?: bool
			// A value used to identify the client to the service provider.
			consumer_key?: string
			// A secret used to establish ownership of the consumer key.
			consumer_secret?: string
			// A value used to gain access to the protected resources on behalf of the user.
			access_token?: string
			// A secret provided in order to establish ownership of a given access token.
			access_token_secret?: string
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// BETA: Allows you to specify JWT authentication.
		jwt?: {
			// Whether to use JWT authentication in requests.
			enabled?: bool
			// A file with the PEM encoded via PKCS1 or PKCS8 as private key.
			private_key_file?: string
			// A method used to sign the token such as RS256, RS384, RS512 or EdDSA.
			signing_method?: string
			// A value used to identify the claims that issued the JWT.
			claims?: {
				[string]: _
			}
			// Add optional key/value headers to the JWT.
			headers?: {
				[string]: _
			}
		}
	}
}
#Output: or([ for name, config in #AllOutputs {
	(name): config
}])
#Output: {
	label?: string
}
#Output: {
	processors?: [...#Processor]
}
#AllProcessors: {
	// Archives all the messages of a batch into a single message according to the selected archive format.
	archive: {
		// The archiving format to apply.
		format: string
		// The path to set for each message in the archive (when applicable).
		path?: string
	}
	// Performs Avro based operations on messages based on a schema.
	avro: {
		// The [operator](#operators) to execute
		operator: string
		// An Avro encoding format to use for conversions to and from a schema.
		encoding?: string
		// A full Avro schema to use.
		schema?: string
		// The path of a schema document to apply. Use either this or the `schema` field.
		schema_path?: string
	}
	// Executes an AWK program on messages. This processor is very powerful as it offers a range of [custom functions](#awk-functions) for querying and mutating message contents and metadata.
	awk: {
		// A [codec](#codecs) defines how messages should be inserted into the AWK program as variables. The codec does not change which [custom Benthos functions](#awk-functions) are available. The `text` codec is the closest to a typical AWK use case.
		codec: string
		// An AWK program to execute
		program: string
	}
	// Executes a PartiQL expression against a DynamoDB table for each message.
	aws_dynamodb_partiql: {
		// A PartiQL query to execute for each message.
		query: string
		// Whether to enable dynamic queries that support interpolation functions.
		unsafe_dynamic_query?: bool
		// A [Bloblang mapping](/docs/guides/bloblang/about) that, for each message, creates a list of arguments to use with the query.
		args_mapping?: string
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
	}
	// Invokes an AWS lambda for each message. The contents of the message is the payload of the request, and the result of the invocation will become the new contents of the message.
	aws_lambda: {
		// Whether messages of a batch should be dispatched in parallel.
		parallel?: bool
		// The function to invoke.
		function: string
		// An optional [`rate_limit`](/docs/components/rate_limits/about) to throttle invocations by.
		rate_limit?: string
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
		// The maximum period of time to wait before abandoning an invocation.
		timeout?: string
		// The maximum number of retry attempts for each message.
		retries?: int
	}
	// Executes a [Bloblang](/docs/guides/bloblang/about) mapping on messages.
	bloblang: string
	// Removes messages (and batches) that do not fit within certain size boundaries.
	bounds_check: {
		// The maximum size of a message to allow (in bytes)
		max_part_size?: int
		// The minimum size of a message to allow (in bytes)
		min_part_size?: int
		// The maximum size of message batches to allow (in message count)
		max_parts?: int
		// The minimum size of message batches to allow (in message count)
		min_parts?: int
	}
	// The `branch` processor allows you to create a new request message via
	// a [Bloblang mapping](/docs/guides/bloblang/about), execute a list of processors
	// on the request messages, and, finally, map the result back into the source
	// message using another mapping.
	branch: {
		// A [Bloblang mapping](/docs/guides/bloblang/about) that describes how to create a request payload suitable for the child processors of this branch. If left empty then the branch will begin with an exact copy of the origin message (including metadata).
		request_map?: string
		// A list of processors to apply to mapped requests. When processing message batches the resulting batch must match the size and ordering of the input batch, therefore filtering, grouping should not be performed within these processors.
		processors?: [...#Processor]
		// A [Bloblang mapping](/docs/guides/bloblang/about) that describes how the resulting messages from branched processing should be mapped back into the original payload. If left empty the origin message will remain unchanged (including metadata).
		result_map?: string
	}
	// Performs operations against a [cache resource](/docs/components/caches/about) for each message, allowing you to store or retrieve data within message payloads.
	cache: {
		// The [`cache` resource](/docs/components/caches/about) to target with this processor.
		resource?: string
		// The [operation](#operators) to perform with the cache.
		operator?: string
		// A key to use with the cache.
		key?: string
		// A value to use with the cache (when applicable).
		value?: string
		// The TTL of each individual item as a duration string. After this period an item will be eligible for removal during the next compaction. Not all caches support per-key TTLs, those that do will have a configuration field `default_ttl`, and those that do not will fall back to their generally configured TTL setting.
		ttl?: string
	}
	// Cache the result of applying one or more processors to messages identified by a key. If the key already exists within the cache the contents of the message will be replaced with the cached result instead of applying the processors. This component is therefore useful in situations where an expensive set of processors need only be executed periodically.
	cached: {
		// The cache resource to read and write processor results from.
		cache: string
		// A condition that can be used to skip caching the results from the processors.
		skip_on?: string
		// A key to be resolved for each message, if the key already exists in the cache then the cached result is used, otherwise the processors are applied and the result is cached under this key. The key could be static and therefore apply generally to all messages or it could be an interpolated expression that is potentially unique for each message.
		key: string
		// An optional expiry period to set for each cache entry. Some caches only have a general TTL and will therefore ignore this setting.
		ttl?: string
		// The list of processors whose result will be cached.
		processors?: [...#Processor]
	}
	// Applies a list of child processors _only_ when a previous processing step has
	// failed.
	catch: [...#Processor]
	// Compresses messages according to the selected algorithm. Supported compression
	// algorithms are: gzip, pgzip, zlib, flate, snappy, lz4.
	compress: {
		// The compression algorithm to use.
		algorithm?: string
		// The level of compression to use. May not be applicable to all algorithms.
		level?: int
	}
	// Performs operations against Couchbase for each message, allowing you to store or retrieve data within message payloads.
	couchbase: {
		// Couchbase connection string.
		url: string
		// Username to connect to the cluster.
		username?: string
		// Password to connect to the cluster.
		password?: string
		// Couchbase bucket.
		bucket: string
		// Bucket collection.
		collection?: string
		// Couchbase transcoder to use.
		transcoder?: string
		// Operation timeout.
		timeout?: string
		// Document id.
		id: string
		// Document content.
		content?: string
		// Couchbase operation to perform.
		operation?: string
	}
	// Decompresses messages according to the selected algorithm. Supported
	// decompression types are: gzip, pgzip, zlib, bzip2, flate, snappy, lz4.
	decompress: {
		// The decompression algorithm to use.
		algorithm?: string
	}
	// Deduplicates messages by storing a key value in a cache using the `add` operator. If the key already exists within the cache it is dropped.
	dedupe: {
		// The [`cache` resource](/docs/components/caches/about) to target with this processor.
		cache?: string
		// An interpolated string yielding the key to deduplicate by for each message.
		key?: string
		// Whether messages should be dropped when the cache returns a general error such as a network issue.
		drop_on_err?: bool
	}
	// A processor that applies a list of child processors to messages of a batch as
	// though they were each a batch of one message.
	for_each: [...#Processor]
	// Executes a `SELECT` query against BigQuery and replaces messages with the rows returned.
	gcp_bigquery_select: {
		// GCP project where the query job will execute.
		project: string
		// Fully-qualified BigQuery table name to query.
		table: string
		// A list of columns to query.
		columns: [...string]
		// An optional where clause to add. Placeholder arguments are populated with the `args_mapping` field. Placeholders should always be question marks (`?`).
		where?: string
		// A list of labels to add to the query job.
		job_labels?: {
			[string]: string
		}
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `where`.
		args_mapping?: string
		// An optional prefix to prepend to the select query (before SELECT).
		prefix?: string
		// An optional suffix to append to the select query.
		suffix?: string
	}
	// Parses messages into a structured format by attempting to apply a list of Grok expressions, the first expression to result in at least one value replaces the original message with a JSON object containing the values.
	grok: {
		// One or more Grok expressions to attempt against incoming messages. The first expression to match at least one value will be used to form a result.
		expressions?: [...string]
		// A map of pattern definitions that can be referenced within `patterns`.
		pattern_definitions?: {
			[string]: string
		}
		// A list of paths to load Grok patterns from. This field supports wildcards, including super globs (double star).
		pattern_paths?: [...string]
		// Whether to only capture values from named patterns.
		named_captures_only?: bool
		// Whether to use a [default set of patterns](#default-patterns).
		use_default_patterns?: bool
		// Whether to remove values that are empty from the resulting structure.
		remove_empty_values?: bool
	}
	// Splits a [batch of messages](/docs/configuration/batching) into N batches, where each resulting batch contains a group of messages determined by a [Bloblang query](/docs/guides/bloblang/about).
	group_by: {
		// A [Bloblang query](/docs/guides/bloblang/about) that should return a boolean value indicating whether a message belongs to a given group.
		check?: string
		// A list of [processors](/docs/components/processors/about) to execute on the newly formed group.
		processors?: [...#Processor]
	}
	// Splits a batch of messages into N batches, where each resulting batch contains a group of messages determined by a [function interpolated string](/docs/configuration/interpolation#bloblang-queries) evaluated per message.
	group_by_value: {
		// The interpolated string to group based on.
		value?: string
	}
	// Performs an HTTP request using a message batch as the request body, and replaces the original message parts with the body of the response.
	http: {
		// The URL to connect to.
		url: string
		// A verb to connect with
		verb?: string
		// A map of headers to add to the request.
		headers?: {
			[string]: string
		}
		// Specify optional matching rules to determine which metadata keys should be added to the HTTP request as headers.
		metadata?: {
			// Provide a list of explicit metadata key prefixes to match against.
			include_prefixes?: [...string]
			// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
			include_patterns?: [...string]
		}
		// EXPERIMENTAL: Optionally set a level at which the request and response payload of each request made will be logged.
		dump_request_log_level?: string
		// Allows you to specify open authentication via OAuth version 1.
		oauth?: {
			// Whether to use OAuth version 1 in requests.
			enabled?: bool
			// A value used to identify the client to the service provider.
			consumer_key?: string
			// A secret used to establish ownership of the consumer key.
			consumer_secret?: string
			// A value used to gain access to the protected resources on behalf of the user.
			access_token?: string
			// A secret provided in order to establish ownership of a given access token.
			access_token_secret?: string
		}
		// Allows you to specify open authentication via OAuth version 2 using the client credentials token flow.
		oauth2?: {
			// Whether to use OAuth version 2 in requests.
			enabled?: bool
			// A value used to identify the client to the token provider.
			client_key?: string
			// A secret used to establish ownership of the client key.
			client_secret?: string
			// The URL of the token provider.
			token_url?: string
			// A list of optional requested permissions.
			scopes?: [...string]
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// BETA: Allows you to specify JWT authentication.
		jwt?: {
			// Whether to use JWT authentication in requests.
			enabled?: bool
			// A file with the PEM encoded via PKCS1 or PKCS8 as private key.
			private_key_file?: string
			// A method used to sign the token such as RS256, RS384, RS512 or EdDSA.
			signing_method?: string
			// A value used to identify the claims that issued the JWT.
			claims?: {
				[string]: _
			}
			// Add optional key/value headers to the JWT.
			headers?: {
				[string]: _
			}
		}
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Specify which response headers should be added to resulting messages as metadata. Header keys are lowercased before matching, so ensure that your patterns target lowercased versions of the header keys that you expect.
		extract_headers?: {
			// Provide a list of explicit metadata key prefixes to match against.
			include_prefixes?: [...string]
			// Provide a list of explicit metadata key regular expression (re2) patterns to match against.
			include_patterns?: [...string]
		}
		// An optional [rate limit](/docs/components/rate_limits/about) to throttle requests by.
		rate_limit?: string
		// A static timeout to apply to requests.
		timeout?: string
		// The base period to wait between failed requests.
		retry_period?: string
		// The maximum period to wait between failed requests.
		max_retry_backoff?: string
		// The maximum number of retry attempts to make.
		retries?: int
		// A list of status codes whereby the request should be considered to have failed and retries should be attempted, but the period between them should be increased gradually.
		backoff_on?: [...int]
		// A list of status codes whereby the request should be considered to have failed but retries should not be attempted. This is useful for preventing wasted retries for requests that will never succeed. Note that with these status codes the _request_ is dropped, but _message_ that caused the request will not be dropped.
		drop_on?: [...int]
		// A list of status codes whereby the attempt should be considered successful, this is useful for dropping requests that return non-2XX codes indicating that the message has been dealt with, such as a 303 See Other or a 409 Conflict. All 2XX codes are considered successful unless they are present within `backoff_on` or `drop_on`, regardless of this field.
		successful_on?: [...int]
		// An optional HTTP proxy URL.
		proxy_url?: string
		// Send message batches as a single request using [RFC1341](https://www.w3.org/Protocols/rfc1341/7_2_Multipart.html).
		batch_as_multipart?: bool
		// When processing batched messages, whether to send messages of the batch in parallel, otherwise they are sent serially.
		parallel?: bool
	}
	// Insert a new message into a batch at an index. If the specified index is greater
	// than the length of the existing batch it will be appended to the end.
	insert_part: {
		// The index within the batch to insert the message at.
		index?: int
		// The content of the message being inserted.
		content?: string
	}
	// Executes a provided JavaScript code block or file for each message.
	javascript: {
		// An inline JavaScript program to run. One of `code` or `file` must be defined.
		code?: string
		// A file containing a JavaScript program to run. One of `code` or `file` must be defined.
		file?: string
		// List of folders that will be used to load modules from if the requested JS module is not found elsewhere.
		global_folders?: [...string]
	}
	// Executes a [JMESPath query](http://jmespath.org/) on JSON documents and replaces
	// the message with the resulting document.
	jmespath: {
		// The JMESPath query to apply to messages.
		query?: string
	}
	// Transforms and filters messages using jq queries.
	jq: {
		// The jq query to filter and transform messages with.
		query?: string
		// Whether to process the input as a raw string instead of as JSON.
		raw?: bool
		// Whether to output raw text (unquoted) instead of JSON strings when the emitted values are string types.
		output_raw?: bool
	}
	// Checks messages against a provided JSONSchema definition but does not change the
	// payload under any circumstances. If a message does not match the schema it can
	// be caught using error handling methods outlined [here](/docs/configuration/error_handling).
	json_schema: {
		// A schema to apply. Use either this or the `schema_path` field.
		schema?: string
		// The path of a schema document to apply. Use either this or the `schema` field.
		schema_path?: string
	}
	// Prints a log event for each message. Messages always remain unchanged. The log message can be set using function interpolations described [here](/docs/configuration/interpolation#bloblang-queries) which allows you to log the contents and metadata of messages.
	log: {
		// The log level to use.
		level?: string
		// A map of fields to print along with the log message.
		fields?: {
			[string]: string
		}
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) that can be used to specify extra fields to add to the log. If log fields are also added with the `fields` field then those values will override matching keys from this mapping.
		fields_mapping?: string
		// The message to print.
		message?: string
	}
	// Executes a [Bloblang](/docs/guides/bloblang/about) mapping on messages, creating a new document that replaces (or filters) the original message.
	mapping: string
	// Emit custom metrics by extracting values from messages.
	metric: {
		// The metric [type](#types) to create.
		type?: string
		// The name of the metric to create, this must be unique across all Benthos components otherwise it will overwrite those other metrics.
		name?: string
		// A map of label names and values that can be used to enrich metrics. Labels are not supported by some metric destinations, in which case the metrics series are combined.
		labels?: {
			[string]: string
		}
		// For some metric types specifies a value to set, increment.
		value?: string
	}
	// Performs operations against MongoDB for each message, allowing you to store or retrieve data within message payloads.
	mongodb: {
		// The URL of the target MongoDB server.
		url: string
		// The name of the target MongoDB database.
		database: string
		// The username to connect to the database.
		username?: string
		// The password to connect to the database.
		password?: string
		// The name of the target collection.
		collection: string
		// The mongodb operation to perform.
		operation?: string
		// The write concern settings for the mongo connection.
		write_concern?: {
			// W requests acknowledgement that write operations propagate to the specified number of mongodb instances.
			w?: string
			// J requests acknowledgement from MongoDB that write operations are written to the journal.
			j?: bool
			// The write concern timeout.
			w_timeout?: string
		}
		// A bloblang map representing the records in the mongo db. Used to generate the document for mongodb by mapping the fields in the message to the mongodb fields. The document map is required for the operations insert-one, replace-one and update-one.
		document_map?: string
		// A bloblang map representing the filter for the mongo db command. The filter map is required for all operations except insert-one. It is used to find the document(s) for the operation. For example in a delete-one case, the filter map should have the fields required to locate the document to delete.
		filter_map?: string
		// A bloblang map representing the hint for the mongo db command. This map is optional and is used with all operations except insert-one. It is used to improve performance of finding the documents in the mongodb.
		hint_map?: string
		// The upsert setting is optional and only applies for update-one and replace-one operations. If the filter specified in filter_map matches, the document is updated or replaced accordingly, otherwise it is created.
		upsert?: bool
		// The json_marshal_mode setting is optional and controls the format of the output message.
		json_marshal_mode?: string
		// The maximum number of retries before giving up on the request. If set to zero there is no discrete limit.
		max_retries?: int
		// Control time intervals between retry attempts.
		backoff?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts.
			max_interval?: string
			// The maximum period to wait before retry attempts are abandoned. If zero then no limit is used.
			max_elapsed_time?: string
		}
	}
	// Converts messages to or from the [MessagePack](https://msgpack.org/) format.
	msgpack: {
		// The operation to perform on messages.
		operator: string
	}
	// Executes a [Bloblang](/docs/guides/bloblang/about) mapping and directly transforms the contents of messages, mutating (or deleting) them.
	mutation: string
	// Perform operations on a NATS key-value bucket.
	nats_kv: {
		// A list of URLs to connect to. If an item of the list contains commas it will be expanded into multiple URLs.
		urls: [...string]
		// The name of the KV bucket to watch for updates.
		bucket: string
		// The operation to perform on the KV bucket.
		operation: string
		// The key for each message.
		key?: string
		// The revision of the key to operate on. Used for `get_revision` and `update` operations.
		revision?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// Optional configuration of NATS authentication parameters.
		auth?: {
			// An optional file containing a NKey seed.
			nkey_file?: string
			// An optional file containing user credentials which consist of an user JWT and corresponding NKey seed.
			user_credentials_file?: string
			// An optional plain text user JWT (given along with the corresponding user NKey Seed).
			user_jwt?: string
			// An optional plain text user NKey Seed (given along with the corresponding user JWT).
			user_nkey_seed?: string
		}
	}
	// Noop is a processor that does nothing, the message passes through unchanged. Why? Sometimes doing nothing is the braver option.
	noop: {}
	// A processor that applies a list of child processors to messages of a batch as though they were each a batch of one message (similar to the [`for_each`](/docs/components/processors/for_each) processor), but where each message is processed in parallel.
	parallel: {
		// The maximum number of messages to have processing at a given time.
		cap?: int
		// A list of child processors to apply.
		processors?: [...#Processor]
	}
	// Converts batches of documents to or from [Parquet files](https://parquet.apache.org/docs/).
	parquet: {
		// Determines whether the processor converts messages into a parquet file or expands parquet files into messages. Converting into JSON allows subsequent processors and mappings to convert the data into any other format.
		operator: string
		// The type of compression to use when writing parquet files, this field is ignored when consuming parquet files.
		compression?: string
		// A file path containing a schema used to describe the parquet files being generated or consumed, the format of the schema is a JSON document detailing the tag and fields of documents. The schema can be found at: https://pkg.go.dev/github.com/xitongsys/parquet-go#readme-json. Either a `schema_file` or `schema` field must be specified when creating Parquet files via the `from_json` operator.
		schema_file?: string
		// A schema used to describe the parquet files being generated or consumed, the format of the schema is a JSON document detailing the tag and fields of documents. The schema can be found at: https://pkg.go.dev/github.com/xitongsys/parquet-go#readme-json. Either a `schema_file` or `schema` field must be specified when creating Parquet files via the `from_json` operator.
		schema?: string
	}
	// Decodes [Parquet files](https://parquet.apache.org/docs/) into a batch of structured messages.
	parquet_decode: {
		// Whether to extract BYTE_ARRAY and FIXED_LEN_BYTE_ARRAY values as strings rather than byte slices in all cases. Values with a logical type of UTF8 will automatically be extracted as strings irrespective of this field. Enabling this field makes serialising the data as JSON more intuitive as `[]byte` values are serialised as base64 encoded strings by default.
		byte_array_as_string?: bool
	}
	// Encodes [Parquet files](https://parquet.apache.org/docs/) from a batch of structured messages.
	parquet_encode: {
		// Parquet schema.
		schema: [...{
			// The name of the column.
			name: string
			// The type of the column, only applicable for leaf columns with no child fields. Some logical types can be specified here such as UTF8.
			type?: string
			// Whether the field is repeated.
			repeated?: bool
			// Whether the field is optional.
			optional?: bool
			// A list of child fields.
			fields?: [...]
		}]
		// The default compression type to use for fields.
		default_compression?: string
		// The default encoding type to use for fields. A custom default encoding is only necessary when consuming data with libraries that do not support `DELTA_LENGTH_BYTE_ARRAY` and is therefore best left unset where possible.
		default_encoding?: string
	}
	// Parses common log [formats](#formats) into [structured data](#codecs). This is
	// easier and often much faster than [`grok`](/docs/components/processors/grok).
	parse_log: {
		// A common log [format](#formats) to parse.
		format?: string
		// Specifies the structured format to parse a log into.
		codec?: string
		// Still returns partially parsed messages even if an error occurs.
		best_effort?: bool
		// Also accept timestamps in rfc3339 format while parsing. Applicable to format `syslog_rfc3164`.
		allow_rfc3339?: bool
		// Sets the strategy used to set the year for rfc3164 timestamps. Applicable to format `syslog_rfc3164`. When set to `current` the current year will be set, when set to an integer that value will be used. Leave this field empty to not set a default year at all.
		default_year?: string
		// Sets the strategy to decide the timezone for rfc3164 timestamps. Applicable to format `syslog_rfc3164`. This value should follow the [time.LoadLocation](https://golang.org/pkg/time/#LoadLocation) format.
		default_timezone?: string
	}
	// Performs conversions to or from a protobuf message. This processor uses
	// reflection, meaning conversions can be made directly from the target .proto
	// files.
	protobuf: {
		// The [operator](#operators) to execute
		operator?: string
		// The fully qualified name of the protobuf message to convert to/from.
		message?: string
		// A list of directories containing .proto files, including all definitions required for parsing the target message. If left empty the current directory is used. Each directory listed will be walked with all found .proto files imported.
		import_paths?: [...string]
	}
	// Throttles the throughput of a pipeline according to a specified
	// [`rate_limit`](/docs/components/rate_limits/about) resource. Rate limits are
	// shared across components and therefore apply globally to all processing
	// pipelines.
	rate_limit: {
		// The target [`rate_limit` resource](/docs/components/rate_limits/about).
		resource?: string
	}
	// Performs actions against Redis that aren't possible using a [`cache`](/docs/components/processors/cache) processor. Actions are
	// performed for each message and the message contents are replaced with the result. In order to merge the result into the original message compose this processor within a [`branch` processor](/docs/components/processors/branch).
	redis: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The command to execute.
		command?: string
		// A [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of arguments required for the specified Redis command.
		args_mapping?: string
		// The operator to apply.
		operator?: string
		// A key to use for the target operator.
		key?: string
		// The maximum number of retries before abandoning a request.
		retries?: int
		// The time to wait before consecutive retry attempts.
		retry_period?: string
	}
	// Performs actions against Redis using [LUA scripts](https://redis.io/docs/manual/programmability/eval-intro/).
	redis_script: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// A script to use for the target operator. It has precedence over the 'command' field.
		script: string
		// A [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of arguments required for the specified Redis script.
		args_mapping: string
		// A [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of keys matching in size to the number of arguments required for the specified Redis script.
		keys_mapping: string
		// The maximum number of retries before abandoning a request.
		retries?: int
		// The time to wait before consecutive retry attempts.
		retry_period?: string
	}
	// Resource is a processor type that runs a processor resource identified by its label.
	resource: string
	// Automatically decodes and validates messages with schemas from a Confluent Schema Registry service.
	schema_registry_decode: {
		// Whether Avro messages should be decoded into normal JSON ("json that meets the expectations of regular internet json") rather than [Avro JSON](https://avro.apache.org/docs/current/specification/_print/#json-encoding). If `true` the schema returned from the subject should be decoded as [standard json](https://pkg.go.dev/github.com/linkedin/goavro/v2#NewCodecForStandardJSONFull) instead of as [avro json](https://pkg.go.dev/github.com/linkedin/goavro/v2#NewCodec). There is a [comment in goavro](https://github.com/linkedin/goavro/blob/5ec5a5ee7ec82e16e6e2b438d610e1cab2588393/union.go#L224-L249), the [underlining library used for avro serialization](https://github.com/linkedin/goavro), that explains in more detail the difference between the standard json and avro json.
		avro_raw_json?: bool
		// The base URL of the schema registry service.
		url: string
		// Allows you to specify open authentication via OAuth version 1.
		oauth?: {
			// Whether to use OAuth version 1 in requests.
			enabled?: bool
			// A value used to identify the client to the service provider.
			consumer_key?: string
			// A secret used to establish ownership of the consumer key.
			consumer_secret?: string
			// A value used to gain access to the protected resources on behalf of the user.
			access_token?: string
			// A secret provided in order to establish ownership of a given access token.
			access_token_secret?: string
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// BETA: Allows you to specify JWT authentication.
		jwt?: {
			// Whether to use JWT authentication in requests.
			enabled?: bool
			// A file with the PEM encoded via PKCS1 or PKCS8 as private key.
			private_key_file?: string
			// A method used to sign the token such as RS256, RS384, RS512 or EdDSA.
			signing_method?: string
			// A value used to identify the claims that issued the JWT.
			claims?: {
				[string]: _
			}
			// Add optional key/value headers to the JWT.
			headers?: {
				[string]: _
			}
		}
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
	}
	// Automatically encodes and validates messages with schemas from a Confluent Schema Registry service.
	schema_registry_encode: {
		// The base URL of the schema registry service.
		url: string
		// The schema subject to derive schemas from.
		subject: string
		// The period after which a schema is refreshed for each subject, this is done by polling the schema registry service.
		refresh_period?: string
		// Whether messages encoded in Avro format should be parsed as normal JSON ("json that meets the expectations of regular internet json") rather than [Avro JSON](https://avro.apache.org/docs/current/specification/_print/#json-encoding). If `true` the schema returned from the subject should be parsed as [standard json](https://pkg.go.dev/github.com/linkedin/goavro/v2#NewCodecForStandardJSONFull) instead of as [avro json](https://pkg.go.dev/github.com/linkedin/goavro/v2#NewCodec). There is a [comment in goavro](https://github.com/linkedin/goavro/blob/5ec5a5ee7ec82e16e6e2b438d610e1cab2588393/union.go#L224-L249), the [underlining library used for avro serialization](https://github.com/linkedin/goavro), that explains in more detail the difference between standard json and avro json.
		avro_raw_json?: bool
		// Allows you to specify open authentication via OAuth version 1.
		oauth?: {
			// Whether to use OAuth version 1 in requests.
			enabled?: bool
			// A value used to identify the client to the service provider.
			consumer_key?: string
			// A secret used to establish ownership of the consumer key.
			consumer_secret?: string
			// A value used to gain access to the protected resources on behalf of the user.
			access_token?: string
			// A secret provided in order to establish ownership of a given access token.
			access_token_secret?: string
		}
		// Allows you to specify basic authentication.
		basic_auth?: {
			// Whether to use basic authentication in requests.
			enabled?: bool
			// A username to authenticate as.
			username?: string
			// A password to authenticate with.
			password?: string
		}
		// BETA: Allows you to specify JWT authentication.
		jwt?: {
			// Whether to use JWT authentication in requests.
			enabled?: bool
			// A file with the PEM encoded via PKCS1 or PKCS8 as private key.
			private_key_file?: string
			// A method used to sign the token such as RS256, RS384, RS512 or EdDSA.
			signing_method?: string
			// A value used to identify the claims that issued the JWT.
			claims?: {
				[string]: _
			}
			// Add optional key/value headers to the JWT.
			headers?: {
				[string]: _
			}
		}
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
	}
	// Cherry pick a set of messages from a batch by their index. Indexes larger than
	// the number of messages are simply ignored.
	select_parts: {
		// An array of message indexes of a batch. Indexes can be negative, and if so the part will be selected from the end counting backwards starting from -1.
		parts?: [...int]
	}
	// Captures log events from messages and submits them to [Sentry](https://sentry.io/).
	sentry_capture: {
		// The DSN address to send sentry events to. If left empty, then SENTRY_DSN is used.
		dsn?: string
		// A message to set on the sentry event
		message: string
		// A mapping that must evaluate to an object-of-objects or `deleted()`. If this mapping produces a value, then it is set on a sentry event as additional context.
		context?: string
		// Sets key/value string tags on an event. Unlike context, these are indexed and searchable on Sentry but have length limitations.
		tags?: {
			[string]: string
		}
		// The environment to be sent with events. If left empty, then SENTRY_ENVIRONMENT is used.
		environment?: string
		// The version of the code deployed to an environment. If left empty, then the Sentry client will attempt to detect the release from the environment.
		release?: string
		// Sets the level on sentry events similar to logging levels.
		level?: string
		// Determines how events are sent. A sync transport will block when sending each event until a response is received from the Sentry server. The recommended async transport will enqueue events in a buffer and send them in the background.
		transport_mode?: string
		// The duration to wait when closing the processor to flush any remaining enqueued events.
		flush_timeout?: string
		// The rate at which events are sent to the server. A value of 0 disables capturing sentry events entirely. A value of 1 results in sending all events to Sentry. Any value in between results sending some percentage of events.
		sampling_rate?: float
	}
	// Sleep for a period of time specified as a duration string for each message. This processor will interpolate functions within the `duration` field, you can find a list of functions [here](/docs/configuration/interpolation#bloblang-queries).
	sleep: {
		// The duration of time to sleep for each execution.
		duration?: string
	}
	// Breaks message batches (synonymous with multiple part messages) into smaller batches. The size of the resulting batches are determined either by a discrete size or, if the field `byte_size` is non-zero, then by total size in bytes (which ever limit is reached first).
	split: {
		// The target number of messages.
		size?: int
		// An optional target of total message bytes.
		byte_size?: int
	}
	// Runs an arbitrary SQL query against a database and (optionally) returns the result as an array of objects, one for each row returned.
	sql: {
		// A database [driver](#drivers) to use.
		driver: string
		// Data source name.
		data_source_name: string
		// The query to execute. The style of placeholder to use depends on the driver, some drivers require question marks (`?`) whereas others expect incrementing dollar signs (`$1`, `$2`, and so on). The style to use is outlined in this table:
		// 
		// | Driver | Placeholder Style |
		// |---|---|
		// | `clickhouse` | Dollar sign |
		// | `mysql` | Question mark |
		// | `postgres` | Dollar sign |
		// | `mssql` | Question mark |
		// | `sqlite` | Question mark |
		// | `oracle` | Colon |
		// | `snowflake` | Question mark |
		// | `trino` | Question mark |
		query: string
		// Whether to enable [interpolation functions](/docs/configuration/interpolation/#bloblang-queries) in the query. Great care should be made to ensure your queries are defended against injection attacks.
		unsafe_dynamic_query?: bool
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `query`.
		args_mapping?: string
		// Result codec.
		result_codec?: string
	}
	// Inserts rows into an SQL database for each message, and leaves the message unchanged.
	sql_insert: {
		// A database [driver](#drivers) to use.
		driver: string
		// A Data Source Name to identify the target database.
		// 
		// #### Drivers
		// 
		// The following is a list of supported drivers, their placeholder style, and their respective DSN formats:
		// 
		// | Driver | Data Source Name Format |
		// |---|---|
		// | `clickhouse` | [`clickhouse://[username[:password]@][netloc][:port]/dbname[?param1=value1&...&paramN=valueN]`](https://github.com/ClickHouse/clickhouse-go#dsn) |
		// | `mysql` | `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]` |
		// | `postgres` | `postgres://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]` |
		// | `mssql` | `sqlserver://[user[:password]@][netloc][:port][?database=dbname&param1=value1&...]` |
		// | `sqlite` | `file:/path/to/filename.db[?param&=value1&...]` |
		// | `oracle` | `oracle://[username[:password]@][netloc][:port]/service_name?server=server2&server=server3` |
		// | `snowflake` | `username[:password]@account_identifier/dbname/schemaname[?param1=value&...&paramN=valueN]` |
		// | `trino` | [`http[s]://user[:pass]@host[:port][?parameters]`](https://github.com/trinodb/trino-go-client#dsn-data-source-name)
		// 
		// Please note that the `postgres` driver enforces SSL by default, you can override this with the parameter `sslmode=disable` if required.
		// 
		// The `snowflake` driver supports multiple DSN formats. Please consult [the docs](https://pkg.go.dev/github.com/snowflakedb/gosnowflake#hdr-Connection_String) for more details. For [key pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth.html#configuring-key-pair-authentication), the DSN has the following format: `<snowflake_user>@<snowflake_account>/<db_name>/<schema_name>?warehouse=<warehouse>&role=<role>&authenticator=snowflake_jwt&privateKey=<base64_url_encoded_private_key>`, where the value for the `privateKey` parameter can be constructed from an unencrypted RSA private key file `rsa_key.p8` using `openssl enc -d -base64 -in rsa_key.p8 | basenc --base64url -w0` (you can use `gbasenc` insted of `basenc` on OSX if you install `coreutils` via Homebrew). If you have a password-encrypted private key, you can decrypt it using `openssl pkcs8 -in rsa_key_encrypted.p8 -out rsa_key.p8`. Also, make sure fields such as the username are URL-encoded.
		dsn: string
		// The table to insert to.
		table: string
		// A list of columns to insert.
		columns: [...string]
		// A [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of columns specified.
		args_mapping: string
		// An optional prefix to prepend to the insert query (before INSERT).
		prefix?: string
		// An optional suffix to append to the insert query.
		suffix?: string
		// An optional list of file paths containing SQL statements to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Glob patterns are supported, including super globs (double star).
		// 
		// Care should be taken to ensure that the statements are idempotent, and therefore would not cause issues when run multiple times after service restarts. If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If a statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_files?: [...string]
		// An optional SQL statement to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Care should be taken to ensure that the statement is idempotent, and therefore would not cause issues when run multiple times after service restarts.
		// 
		// If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If the statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_statement?: string
		// An optional maximum amount of time a connection may be idle. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's idle time.
		conn_max_idle_time?: string
		// An optional maximum amount of time a connection may be reused. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's age.
		conn_max_life_time?: string
		// An optional maximum number of connections in the idle connection pool. If conn_max_open is greater than 0 but less than the new conn_max_idle, then the new conn_max_idle will be reduced to match the conn_max_open limit. If value <= 0, no idle connections are retained. The default max idle connections is currently 2. This may change in a future release.
		conn_max_idle?: int
		// An optional maximum number of open connections to the database. If conn_max_idle is greater than 0 and the new conn_max_open is less than conn_max_idle, then conn_max_idle will be reduced to match the new conn_max_open limit. If value <= 0, then there is no limit on the number of open connections. The default is 0 (unlimited).
		conn_max_open?: int
	}
	// Runs an arbitrary SQL query against a database and (optionally) returns the result as an array of objects, one for each row returned.
	sql_raw: {
		// A database [driver](#drivers) to use.
		driver: string
		// A Data Source Name to identify the target database.
		// 
		// #### Drivers
		// 
		// The following is a list of supported drivers, their placeholder style, and their respective DSN formats:
		// 
		// | Driver | Data Source Name Format |
		// |---|---|
		// | `clickhouse` | [`clickhouse://[username[:password]@][netloc][:port]/dbname[?param1=value1&...&paramN=valueN]`](https://github.com/ClickHouse/clickhouse-go#dsn) |
		// | `mysql` | `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]` |
		// | `postgres` | `postgres://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]` |
		// | `mssql` | `sqlserver://[user[:password]@][netloc][:port][?database=dbname&param1=value1&...]` |
		// | `sqlite` | `file:/path/to/filename.db[?param&=value1&...]` |
		// | `oracle` | `oracle://[username[:password]@][netloc][:port]/service_name?server=server2&server=server3` |
		// | `snowflake` | `username[:password]@account_identifier/dbname/schemaname[?param1=value&...&paramN=valueN]` |
		// | `trino` | [`http[s]://user[:pass]@host[:port][?parameters]`](https://github.com/trinodb/trino-go-client#dsn-data-source-name)
		// 
		// Please note that the `postgres` driver enforces SSL by default, you can override this with the parameter `sslmode=disable` if required.
		// 
		// The `snowflake` driver supports multiple DSN formats. Please consult [the docs](https://pkg.go.dev/github.com/snowflakedb/gosnowflake#hdr-Connection_String) for more details. For [key pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth.html#configuring-key-pair-authentication), the DSN has the following format: `<snowflake_user>@<snowflake_account>/<db_name>/<schema_name>?warehouse=<warehouse>&role=<role>&authenticator=snowflake_jwt&privateKey=<base64_url_encoded_private_key>`, where the value for the `privateKey` parameter can be constructed from an unencrypted RSA private key file `rsa_key.p8` using `openssl enc -d -base64 -in rsa_key.p8 | basenc --base64url -w0` (you can use `gbasenc` insted of `basenc` on OSX if you install `coreutils` via Homebrew). If you have a password-encrypted private key, you can decrypt it using `openssl pkcs8 -in rsa_key_encrypted.p8 -out rsa_key.p8`. Also, make sure fields such as the username are URL-encoded.
		dsn: string
		// The query to execute. The style of placeholder to use depends on the driver, some drivers require question marks (`?`) whereas others expect incrementing dollar signs (`$1`, `$2`, and so on). The style to use is outlined in this table:
		// 
		// | Driver | Placeholder Style |
		// |---|---|
		// | `clickhouse` | Dollar sign |
		// | `mysql` | Question mark |
		// | `postgres` | Dollar sign |
		// | `mssql` | Question mark |
		// | `sqlite` | Question mark |
		// | `oracle` | Colon |
		// | `snowflake` | Question mark |
		// | `trino` | Question mark |
		query: string
		// Whether to enable [interpolation functions](/docs/configuration/interpolation/#bloblang-queries) in the query. Great care should be made to ensure your queries are defended against injection attacks.
		unsafe_dynamic_query?: bool
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `query`.
		args_mapping?: string
		// Whether the query result should be discarded. When set to `true` the message contents will remain unchanged, which is useful in cases where you are executing inserts, updates, etc.
		exec_only?: bool
		// An optional list of file paths containing SQL statements to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Glob patterns are supported, including super globs (double star).
		// 
		// Care should be taken to ensure that the statements are idempotent, and therefore would not cause issues when run multiple times after service restarts. If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If a statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_files?: [...string]
		// An optional SQL statement to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Care should be taken to ensure that the statement is idempotent, and therefore would not cause issues when run multiple times after service restarts.
		// 
		// If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If the statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_statement?: string
		// An optional maximum amount of time a connection may be idle. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's idle time.
		conn_max_idle_time?: string
		// An optional maximum amount of time a connection may be reused. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's age.
		conn_max_life_time?: string
		// An optional maximum number of connections in the idle connection pool. If conn_max_open is greater than 0 but less than the new conn_max_idle, then the new conn_max_idle will be reduced to match the conn_max_open limit. If value <= 0, no idle connections are retained. The default max idle connections is currently 2. This may change in a future release.
		conn_max_idle?: int
		// An optional maximum number of open connections to the database. If conn_max_idle is greater than 0 and the new conn_max_open is less than conn_max_idle, then conn_max_idle will be reduced to match the new conn_max_open limit. If value <= 0, then there is no limit on the number of open connections. The default is 0 (unlimited).
		conn_max_open?: int
	}
	// Runs an SQL select query against a database and returns the result as an array of objects, one for each row returned, containing a key for each column queried and its value.
	sql_select: {
		// A database [driver](#drivers) to use.
		driver: string
		// A Data Source Name to identify the target database.
		// 
		// #### Drivers
		// 
		// The following is a list of supported drivers, their placeholder style, and their respective DSN formats:
		// 
		// | Driver | Data Source Name Format |
		// |---|---|
		// | `clickhouse` | [`clickhouse://[username[:password]@][netloc][:port]/dbname[?param1=value1&...&paramN=valueN]`](https://github.com/ClickHouse/clickhouse-go#dsn) |
		// | `mysql` | `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]` |
		// | `postgres` | `postgres://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]` |
		// | `mssql` | `sqlserver://[user[:password]@][netloc][:port][?database=dbname&param1=value1&...]` |
		// | `sqlite` | `file:/path/to/filename.db[?param&=value1&...]` |
		// | `oracle` | `oracle://[username[:password]@][netloc][:port]/service_name?server=server2&server=server3` |
		// | `snowflake` | `username[:password]@account_identifier/dbname/schemaname[?param1=value&...&paramN=valueN]` |
		// | `trino` | [`http[s]://user[:pass]@host[:port][?parameters]`](https://github.com/trinodb/trino-go-client#dsn-data-source-name)
		// 
		// Please note that the `postgres` driver enforces SSL by default, you can override this with the parameter `sslmode=disable` if required.
		// 
		// The `snowflake` driver supports multiple DSN formats. Please consult [the docs](https://pkg.go.dev/github.com/snowflakedb/gosnowflake#hdr-Connection_String) for more details. For [key pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth.html#configuring-key-pair-authentication), the DSN has the following format: `<snowflake_user>@<snowflake_account>/<db_name>/<schema_name>?warehouse=<warehouse>&role=<role>&authenticator=snowflake_jwt&privateKey=<base64_url_encoded_private_key>`, where the value for the `privateKey` parameter can be constructed from an unencrypted RSA private key file `rsa_key.p8` using `openssl enc -d -base64 -in rsa_key.p8 | basenc --base64url -w0` (you can use `gbasenc` insted of `basenc` on OSX if you install `coreutils` via Homebrew). If you have a password-encrypted private key, you can decrypt it using `openssl pkcs8 -in rsa_key_encrypted.p8 -out rsa_key.p8`. Also, make sure fields such as the username are URL-encoded.
		dsn: string
		// The table to query.
		table: string
		// A list of columns to query.
		columns: [...string]
		// An optional where clause to add. Placeholder arguments are populated with the `args_mapping` field. Placeholders should always be question marks, and will automatically be converted to dollar syntax when the postgres or clickhouse drivers are used.
		where?: string
		// An optional [Bloblang mapping](/docs/guides/bloblang/about) which should evaluate to an array of values matching in size to the number of placeholder arguments in the field `where`.
		args_mapping?: string
		// An optional prefix to prepend to the query (before SELECT).
		prefix?: string
		// An optional suffix to append to the select query.
		suffix?: string
		// An optional list of file paths containing SQL statements to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Glob patterns are supported, including super globs (double star).
		// 
		// Care should be taken to ensure that the statements are idempotent, and therefore would not cause issues when run multiple times after service restarts. If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If a statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_files?: [...string]
		// An optional SQL statement to execute immediately upon the first connection to the target database. This is a useful way to initialise tables before processing data. Care should be taken to ensure that the statement is idempotent, and therefore would not cause issues when run multiple times after service restarts.
		// 
		// If both `init_statement` and `init_files` are specified the `init_statement` is executed _after_ the `init_files`.
		// 
		// If the statement fails for any reason a warning log will be emitted but the operation of this component will not be stopped.
		init_statement?: string
		// An optional maximum amount of time a connection may be idle. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's idle time.
		conn_max_idle_time?: string
		// An optional maximum amount of time a connection may be reused. Expired connections may be closed lazily before reuse. If value <= 0, connections are not closed due to a connection's age.
		conn_max_life_time?: string
		// An optional maximum number of connections in the idle connection pool. If conn_max_open is greater than 0 but less than the new conn_max_idle, then the new conn_max_idle will be reduced to match the conn_max_open limit. If value <= 0, no idle connections are retained. The default max idle connections is currently 2. This may change in a future release.
		conn_max_idle?: int
		// An optional maximum number of open connections to the database. If conn_max_idle is greater than 0 and the new conn_max_open is less than conn_max_idle, then conn_max_idle will be reduced to match the new conn_max_open limit. If value <= 0, then there is no limit on the number of open connections. The default is 0 (unlimited).
		conn_max_open?: int
	}
	// Executes a command as a subprocess and, for each message, will pipe its contents to the stdin stream of the process followed by a newline.
	subprocess: {
		// The command to execute as a subprocess.
		name?: string
		// A list of arguments to provide the command.
		args?: [...string]
		// The maximum expected response size.
		max_buffer?: int
		// Determines how messages written to the subprocess are encoded, which allows them to be logically separated.
		codec_send?: string
		// Determines how messages read from the subprocess are decoded, which allows them to be logically separated.
		codec_recv?: string
	}
	// Conditionally processes messages based on their contents.
	switch: {
		// A [Bloblang query](/docs/guides/bloblang/about) that should return a boolean value indicating whether a message should have the processors of this case executed on it. If left empty the case always passes. If the check mapping throws an error the message will be flagged [as having failed](/docs/configuration/error_handling) and will not be tested against any other cases.
		check?: string
		// A list of [processors](/docs/components/processors/about/) to execute on a message.
		processors?: [...#Processor]
		// Indicates whether, if this case passes for a message, the next case should also be executed.
		fallthrough?: bool
	}
	// Adds the payload in its current state as a synchronous response to the input
	// source, where it is dealt with according to that specific input type.
	sync_response: {}
	// Executes a list of child processors on messages only if no prior processors have failed (or the errors have been cleared).
	try: [...#Processor]
	// Unarchives messages according to the selected archive format into multiple messages within a [batch](/docs/configuration/batching).
	unarchive: {
		// The unarchiving format to apply.
		format: string
	}
	// Executes a function exported by a WASM module for each message.
	wasm: {
		// The path of the target WASM module to execute.
		module_path: string
		// The name of the function exported by the target WASM module to run for each message.
		function?: string
	}
	// A processor that checks a [Bloblang query](/docs/guides/bloblang/about/) against each batch of messages and executes child processors on them for as long as the query resolves to true.
	while: {
		// Whether to always run the child processors at least one time.
		at_least_once?: bool
		// An optional maximum number of loops to execute. Helps protect against accidentally creating infinite loops.
		max_loops?: int
		// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether the while loop should execute again.
		check?: string
		// A list of child processors to execute on each loop.
		processors?: [...#Processor]
	}
	// Executes a topology of [`branch` processors][processors.branch],
	// performing them in parallel where possible.
	workflow: {
		// A [dot path](/docs/configuration/field_paths) indicating where to store and reference [structured metadata](#structured-metadata) about the workflow execution.
		meta_path?: string
		// An explicit declaration of branch ordered tiers, which describes the order in which parallel tiers of branches should be executed. Branches should be identified by the name as they are configured in the field `branches`. It's also possible to specify branch processors configured [as a resource](#resources).
		order?: [[...string]]
		// An optional list of [`branch` processor](/docs/components/processors/branch) names that are configured as [resources](#resources). These resources will be included in the workflow with any branches configured inline within the [`branches`](#branches) field. The order and parallelism in which branches are executed is automatically resolved based on the mappings of each branch. When using resources with an explicit order it is not necessary to list resources in this field.
		branch_resources?: [...string]
		// An object of named [`branch` processors](/docs/components/processors/branch) that make up the workflow. The order and parallelism in which branches are executed can either be made explicit with the field `order`, or if omitted an attempt is made to automatically resolve an ordering based on the mappings of each branch.
		branches?: {
			[string]: {
				// A [Bloblang mapping](/docs/guides/bloblang/about) that describes how to create a request payload suitable for the child processors of this branch. If left empty then the branch will begin with an exact copy of the origin message (including metadata).
				request_map?: string
				// A list of processors to apply to mapped requests. When processing message batches the resulting batch must match the size and ordering of the input batch, therefore filtering, grouping should not be performed within these processors.
				processors?: [...#Processor]
				// A [Bloblang mapping](/docs/guides/bloblang/about) that describes how the resulting messages from branched processing should be mapped back into the original payload. If left empty the origin message will remain unchanged (including metadata).
				result_map?: string
			}
		}
	}
	// Parses messages as an XML document, performs a mutation on the data, and then
	// overwrites the previous contents with the new value.
	xml: {
		// An XML [operation](#operators) to apply to messages.
		operator?: string
		// Whether to try to cast values that are numbers and booleans to the right type. Default: all values are strings.
		cast?: bool
	}
}
#Processor: or([ for name, config in #AllProcessors {
	(name): config
}])
#Processor: {
	label?: string
}
#AllCaches: {
	// Stores key/value pairs as a single document in a DynamoDB table. The key is stored as a string value and used as the table hash key. The value is stored as
	// a binary value using the `data_key` field name.
	aws_dynamodb: {
		// The table to store items in.
		table: string
		// The key of the table column to store item keys within.
		hash_key: string
		// The key of the table column to store item values within.
		data_key: string
		// Whether to use strongly consistent reads on Get commands.
		consistent_read?: bool
		// An optional default TTL to set for items, calculated from the moment the item is cached. A `ttl_key` must be specified in order to set item TTLs.
		default_ttl?: string
		// The column key to place the TTL value within.
		ttl_key?: string
		// Determine time intervals and cut offs for retry attempts.
		retries?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts
			max_interval?: string
			// The maximum overall period of time to spend on retry attempts before the request is aborted.
			max_elapsed_time?: string
		}
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
	}
	// Stores each item in an S3 bucket as a file, where an item ID is the path of the item within the bucket.
	aws_s3: {
		// The S3 bucket to store items in.
		bucket: string
		// The content type to set for each item.
		content_type?: string
		// Forces the client API to use path style URLs, which helps when connecting to custom endpoints.
		force_path_style_urls?: bool
		// Determine time intervals and cut offs for retry attempts.
		retries?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts
			max_interval?: string
			// The maximum overall period of time to spend on retry attempts before the request is aborted.
			max_elapsed_time?: string
		}
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
	}
	// Use a Couchbase instance as a cache.
	couchbase: {
		// Couchbase connection string.
		url: string
		// Username to connect to the cluster.
		username?: string
		// Password to connect to the cluster.
		password?: string
		// Couchbase bucket.
		bucket: string
		// Bucket collection.
		collection?: string
		// Couchbase transcoder to use.
		transcoder?: string
		// Operation timeout.
		timeout?: string
		// An optional default TTL to set for items, calculated from the moment the item is cached.
		default_ttl?: string
	}
	// Stores each item in a directory as a file, where an item ID is the path relative to the configured directory.
	file: {
		// The directory within which to store items.
		directory: string
	}
	// Use a Google Cloud Storage bucket as a cache.
	gcp_cloud_storage: {
		// The Google Cloud Storage bucket to store items in.
		bucket: string
		// Optional field to explicitly set the Content-Type.
		content_type?: string
	}
	// Stores key/value pairs in a lru in-memory cache. This cache is therefore reset every time the service restarts.
	lru: {
		// The cache maximum capacity (number of entries)
		cap?: int
		// A table of key/value pairs that should be present in the cache on initialization. This can be used to create static lookup tables.
		init_values?: {
			[string]: string
		}
		// the lru cache implementation
		algorithm?: string
		// is the ratio of the two_queues cache dedicated to recently added entries that have only been accessed once.
		two_queues_recent_ratio?: float
		// is the default ratio of ghost entries kept to track entries recently evicted on two_queues cache.
		two_queues_ghost_ratio?: float
		// If true, we do not lock on read/write events. The lru package is thread-safe, however the ADD operation is not atomic.
		optimistic?: bool
	}
	// Connects to a cluster of memcached services, a prefix can be specified to allow multiple cache types to share a memcached cluster under different namespaces.
	memcached: {
		// A list of addresses of memcached servers to use.
		addresses: [...string]
		// An optional string to prefix item keys with in order to prevent collisions with similar services.
		prefix?: string
		// A default TTL to set for items, calculated from the moment the item is cached.
		default_ttl?: string
		// Determine time intervals and cut offs for retry attempts.
		retries?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts
			max_interval?: string
			// The maximum overall period of time to spend on retry attempts before the request is aborted.
			max_elapsed_time?: string
		}
	}
	// Stores key/value pairs in a map held in memory. This cache is therefore reset every time the service restarts. Each item in the cache has a TTL set from the moment it was last edited, after which it will be removed during the next compaction.
	memory: {
		// The default TTL of each item. After this period an item will be eligible for removal during the next compaction.
		default_ttl?: string
		// The period of time to wait before each compaction, at which point expired items are removed. This field can be set to an empty string in order to disable compactions/expiry entirely.
		compaction_interval?: string
		// A table of key/value pairs that should be present in the cache on initialization. This can be used to create static lookup tables.
		init_values?: {
			[string]: string
		}
		// A number of logical shards to spread keys across, increasing the shards can have a performance benefit when processing a large number of keys.
		shards?: int
	}
	// Use a MongoDB instance as a cache.
	mongodb: {
		// The URL of the target MongoDB server.
		url: string
		// The name of the target MongoDB database.
		database: string
		// The username to connect to the database.
		username?: string
		// The password to connect to the database.
		password?: string
		// The name of the target collection.
		collection: string
		// The field in the document that is used as the key.
		key_field: string
		// The field in the document that is used as the value.
		value_field: string
	}
	// Combines multiple caches as levels, performing read-through and write-through operations across them.
	multilevel: [...string]
	// Use a Redis instance as a cache. The expiration can be set to zero or an empty string in order to set no expiration.
	redis: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// An optional string to prefix item keys with in order to prevent collisions with similar services.
		prefix?: string
		// An optional default TTL to set for items, calculated from the moment the item is cached.
		default_ttl?: string
		// Determine time intervals and cut offs for retry attempts.
		retries?: {
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts
			max_interval?: string
			// The maximum overall period of time to spend on retry attempts before the request is aborted.
			max_elapsed_time?: string
		}
	}
	// Stores key/value pairs in a map held in the memory-bound [Ristretto cache](https://github.com/dgraph-io/ristretto).
	ristretto: {
		// A default TTL to set for items, calculated from the moment the item is cached. Set to an empty string or zero duration to disable TTLs.
		default_ttl?: string
		// Determines how and whether get attempts should be retried if the key is not found. Ristretto is a concurrent cache that does not immediately reflect writes, and so it can sometimes be useful to enable retries at the cost of speed in cases where the key is expected to exist.
		get_retries?: {
			// Whether retries should be enabled.
			enabled?: bool
			// The initial period to wait between retry attempts.
			initial_interval?: string
			// The maximum period to wait between retry attempts
			max_interval?: string
			// The maximum overall period of time to spend on retry attempts before the request is aborted.
			max_elapsed_time?: string
		}
	}
	// Stores key/value pairs in a ttlru in-memory cache. This cache is therefore reset every time the service restarts.
	ttlru: {
		// The cache maximum capacity (number of entries)
		cap?: int
		// The cache ttl of each element
		ttl?: string
		// A table of key/value pairs that should be present in the cache on initialization. This can be used to create static lookup tables.
		init_values?: {
			[string]: string
		}
		// If true, we stop reset the ttl on read events.
		without_reset?: bool
		// If true, we do not lock on read/write events. The ttlru package is thread-safe, however the ADD operation is not atomic.
		optimistic?: bool
	}
}
#Cache: or([ for name, config in #AllCaches {
	(name): config
}])
#AllRateLimits: {
	// The local rate limit is a simple X every Y type rate limit that can be shared across any number of components within the pipeline but does not support distributed rate limits across multiple running instances of Benthos.
	local: {
		// The maximum number of requests to allow for a given period of time.
		count?: int
		// The time window to limit requests by.
		interval?: string
	}
	// A rate limit implementation using Redis. It works by using a simple token bucket algorithm to limit the number of requests to a given count within a given time period. The rate limit is shared across all instances of Benthos that use the same Redis instance, which must all have a consistent count and interval.
	redis: {
		// The URL of the target Redis server. Database is optional and is supplied as the URL path.
		url: string
		// Specifies a simple, cluster-aware, or failover-aware redis client.
		kind?: string
		// Name of the redis master when `kind` is `failover`
		master?: string
		// Custom TLS settings can be used to override system defaults.
		// 
		// **Troubleshooting**
		// 
		// Some cloud hosted instances of Redis (such as Azure Cache) might need some hand holding in order to establish stable connections. Unfortunately, it is often the case that TLS issues will manifest as generic error messages such as "i/o timeout". If you're using TLS and are seeing connectivity problems consider setting `enable_renegotiation` to `true`, and ensuring that the server supports at least TLS version 1.2.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// The maximum number of messages to allow for a given period of time.
		count?: int
		// The time window to limit requests by.
		interval?: string
		// The key to use for the rate limit.
		key: string
	}
}
#RateLimit: or([ for name, config in #AllRateLimits {
	(name): config
}])
#AllBuffers: {
	// Stores consumed messages in memory and acknowledges them at the input level. During shutdown Benthos will make a best attempt at flushing all remaining messages before exiting cleanly.
	memory: {
		// The maximum buffer size (in bytes) to allow before applying backpressure upstream.
		limit?: int
		// Optionally configure a policy to flush buffered messages in batches.
		batch_policy?: {
			// Whether to batch messages as they are flushed.
			enabled?: bool
			// A number of messages at which the batch should be flushed. If `0` disables count based batching.
			count?: int
			// An amount of bytes at which the batch should be flushed. If `0` disables size based batching.
			byte_size?: int
			// A period in which an incomplete batch should be flushed regardless of its size.
			period?: string
			// A [Bloblang query](/docs/guides/bloblang/about/) that should return a boolean value indicating whether a message should end a batch.
			check?: string
			// A list of [processors](/docs/components/processors/about) to apply to a batch as it is flushed. This allows you to aggregate and archive the batch however you see fit. Please note that all resulting messages are flushed as a single batch, therefore splitting the batch into smaller batches using these processors is a no-op.
			processors?: [...#Processor]
		}
	}
	// Do not buffer messages. This is the default and most resilient configuration.
	none: {}
	// Stores messages in an SQLite database and acknowledges them at the input level.
	sqlite: {
		// The path of the database file, which will be created if it does not already exist.
		path: string
		// An optional list of processors to apply to messages before they are stored within the buffer. These processors are useful for compressing, archiving or otherwise reducing the data in size before it's stored on disk.
		pre_processors?: [...#Processor]
		// An optional list of processors to apply to messages after they are consumed from the buffer. These processors are useful for undoing any compression, archiving, etc that may have been done by your `pre_processors`.
		post_processors?: [...#Processor]
	}
	// Chops a stream of messages into tumbling or sliding windows of fixed temporal size, following the system clock.
	system_window: {
		// A [Bloblang mapping](/docs/guides/bloblang/about) applied to each message during ingestion that provides the timestamp to use for allocating it a window. By default the function `now()` is used in order to generate a fresh timestamp at the time of ingestion (the processing time), whereas this mapping can instead extract a timestamp from the message itself (the event time).
		// 
		// The timestamp value assigned to `root` must either be a numerical unix time in seconds (with up to nanosecond precision via decimals), or a string in ISO 8601 format. If the mapping fails or provides an invalid result the message will be dropped (with logging to describe the problem).
		timestamp_mapping?: string
		// A duration string describing the size of each window. By default windows are aligned to the zeroth minute and zeroth hour on the UTC clock, meaning windows of 1 hour duration will match the turn of each hour in the day, this can be adjusted with the `offset` field.
		size: string
		// An optional duration string describing by how much time the beginning of each window should be offset from the beginning of the previous, and therefore creates sliding windows instead of tumbling. When specified this duration must be smaller than the `size` of the window.
		slide?: string
		// An optional duration string to offset the beginning of each window by, otherwise they are aligned to the zeroth minute and zeroth hour on the UTC clock. The offset cannot be a larger or equal measure to the window size or the slide.
		offset?: string
		// An optional duration string describing the length of time to wait after a window has ended before flushing it, allowing late arrivals to be included. Since this windowing buffer uses the system clock an allowed lateness can improve the matching of messages when using event time.
		allowed_lateness?: string
	}
}
#Buffer: or([ for name, config in #AllBuffers {
	(name): config
}])
#AllMetrics: {
	// Send metrics to AWS CloudWatch using the PutMetricData endpoint.
	aws_cloudwatch: {
		// The namespace used to distinguish metrics from other services.
		namespace?: string
		// The period of time between PutMetricData requests.
		flush_period?: string
		// The AWS region to target.
		region?: string
		// Allows you to specify a custom endpoint for the AWS API.
		endpoint?: string
		// Optional manual configuration of AWS credentials to use. More information can be found [in this document](/docs/guides/cloud/aws).
		credentials?: {
			// A profile from `~/.aws/credentials` to use.
			profile?: string
			// The ID of credentials to use.
			id?: string
			// The secret for the credentials being used.
			secret?: string
			// The token for the credentials being used, required when using short term credentials.
			token?: string
			// Use the credentials of a host EC2 machine configured to assume [an IAM role associated with the instance](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).
			from_ec2_role?: bool
			// A role ARN to assume.
			role?: string
			// An external ID to provide when assuming a role.
			role_external_id?: string
		}
	}
	// Send metrics to InfluxDB 1.x using the `/write` endpoint.
	influxdb: {
		// A URL of the format `[https|http|udp]://host:port` to the InfluxDB host.
		url?: string
		// The name of the database to use.
		db?: string
		// Custom TLS settings can be used to override system defaults.
		tls?: {
			// Whether custom TLS settings are enabled.
			enabled?: bool
			// Whether to skip server side certificate verification.
			skip_cert_verify?: bool
			// Whether to allow the remote server to repeatedly request renegotiation. Enable this option if you're seeing the error message `local error: tls: no renegotiation`.
			enable_renegotiation?: bool
			// An optional root certificate authority to use. This is a string, representing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas?: string
			// An optional path of a root certificate authority file to use. This is a file, often with a .pem extension, containing a certificate chain from the parent trusted root certificate, to possible intermediate signing certificates, to the host certificate.
			root_cas_file?: string
			// A list of client certificates to use. For each certificate either the fields `cert` and `key`, or `cert_file` and `key_file` should be specified, but not both.
			client_certs?: [...{
				// A plain text certificate to use.
				cert?: string
				// A plain text certificate key to use.
				key?: string
				// The path of a certificate to use.
				cert_file?: string
				// The path of a certificate key to use.
				key_file?: string
				// A plain text password for when the private key is password encrypted in PKCS#1 or PKCS#8 format. The obsolete `pbeWithMD5AndDES-CBC` algorithm is not supported for the PKCS#8 format. Warning: Since it does not authenticate the ciphertext, it is vulnerable to padding oracle attacks that can let an attacker recover the plaintext.
				password?: string
			}]
		}
		// A username (when applicable).
		username?: string
		// A password (when applicable).
		password?: string
		// Optional additional metrics to collect, enabling these metrics may have some performance implications as it acquires a global semaphore and does `stoptheworld()`.
		include?: {
			// A duration string indicating how often to poll and collect runtime metrics. Leave empty to disable this metric
			runtime?: string
			// A duration string indicating how often to poll and collect GC metrics. Leave empty to disable this metric.
			debug_gc?: string
		}
		// A duration string indicating how often metrics should be flushed.
		interval?: string
		// A duration string indicating how often to ping the host.
		ping_interval?: string
		// [ns|us|ms|s] timestamp precision passed to write api.
		precision?: string
		// How long to wait for response for both ping and writing metrics.
		timeout?: string
		// Global tags added to each metric.
		tags?: {
			[string]: string
		}
		// Sets the retention policy for each write.
		retention_policy?: string
		// [any|one|quorum|all] sets write consistency when available.
		write_consistency?: string
	}
	// Serves metrics as JSON object with the service wide HTTP service at the endpoints `/stats` and `/metrics`.
	json_api: {}
	// Prints aggregated metrics through the logger.
	logger: {
		// An optional period of time to continuously print all metrics.
		push_interval?: string
		// Whether counters and timing metrics should be reset to 0 each time metrics are printed.
		flush_metrics?: bool
	}
	// Disable metrics entirely.
	none: {}
	// Host endpoints (`/metrics` and `/stats`) for Prometheus scraping.
	prometheus: {
		// Whether to export timing metrics as a histogram, if `false` a summary is used instead. When exporting histogram timings the delta values are converted from nanoseconds into seconds in order to better fit within bucket definitions. For more information on histograms and summaries refer to: https://prometheus.io/docs/practices/histograms/.
		use_histogram_timing?: bool
		// Timing metrics histogram buckets (in seconds). If left empty defaults to DefBuckets (https://pkg.go.dev/github.com/prometheus/client_golang/prometheus#pkg-variables)
		histogram_buckets?: [...float]
		// Whether to export process metrics such as CPU and memory usage in addition to Benthos metrics.
		add_process_metrics?: bool
		// Whether to export Go runtime metrics such as GC pauses in addition to Benthos metrics.
		add_go_metrics?: bool
		// An optional [Push Gateway URL](#push-gateway) to push metrics to.
		push_url?: string
		// The period of time between each push when sending metrics to a Push Gateway.
		push_interval?: string
		// An identifier for push jobs.
		push_job_name?: string
		// The Basic Authentication credentials.
		push_basic_auth?: {
			// The Basic Authentication username.
			username?: string
			// The Basic Authentication password.
			password?: string
		}
		// An optional file path to write all prometheus metrics on service shutdown.
		file_output_path?: string
	}
	// Pushes metrics using the [StatsD protocol](https://github.com/statsd/statsd).
	// Supported tagging formats are 'none', 'datadog' and 'influxdb'.
	statsd: {
		// The address to send metrics to.
		address?: string
		// The time interval between metrics flushes.
		flush_period?: string
		// Metrics tagging is supported in a variety of formats.
		tag_format?: string
	}
}
#Metric: or([ for name, config in #AllMetrics {
	(name): config
}])
#AllTracers: {
	// Send tracing events to a [Google Cloud Trace](https://cloud.google.com/trace).
	gcp_cloudtrace: {
		// The google project with Cloud Trace API enabled. If this is omitted then the Google Cloud SDK will attempt auto-detect it from the environment.
		project?: string
		// Sets the ratio of traces to sample. Tuning the sampling ratio is recommended for high-volume production workloads.
		sampling_ratio?: float
		// A map of tags to add to tracing spans.
		tags?: {
			[string]: string
		}
		// The period of time between each flush of tracing spans.
		flush_interval?: string
	}
	// Send tracing events to a [Jaeger](https://www.jaegertracing.io/) agent or collector.
	jaeger: {
		// The address of a Jaeger agent to send tracing events to.
		agent_address?: string
		// The URL of a Jaeger collector to send tracing events to. If set, this will override `agent_address`.
		collector_url?: string
		// The sampler type to use.
		sampler_type?: string
		// A parameter to use for sampling. This field is unused for some sampling types.
		sampler_param?: float
		// A map of tags to add to tracing spans.
		tags?: {
			[string]: string
		}
		// The period of time between each flush of tracing spans.
		flush_interval?: string
	}
	// Do not send tracing events anywhere.
	none: {}
	// Send tracing events to an [Open Telemetry collector](https://opentelemetry.io/docs/collector/).
	open_telemetry_collector: {
		// A list of http collectors.
		http?: [...{
			// The URL of a collector to send tracing events to.
			url?: string
		}]
		// A list of grpc collectors.
		grpc?: [...{
			// The URL of a collector to send tracing events to.
			url?: string
		}]
		// A map of tags to add to all tracing spans.
		tags?: {
			[string]: string
		}
	}
}
#Tracer: or([ for name, config in #AllTracers {
	(name): config
}])
