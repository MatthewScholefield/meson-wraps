project(
	'uWS',
	'cpp',
	default_options : ['cpp_std=c++11']
)

deps = [
	dependency('threads'),
	dependency('libcrypto'),
	dependency('openssl'),
	dependency('zlib'),
	dependency('libuv')
]

inc = include_directories('src')

subdir('src')

dep = declare_dependency(link_with : lib,
	dependencies: deps,
	include_directories : inc)

