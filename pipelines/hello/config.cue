package hello

input: generate: mapping: """
	root = {"message": "Hello World", "id": nanoid()}
	"""

output: stdout: {}
