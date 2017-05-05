project('jsonxx', 'cpp')

inc = include_directories('.')
lib = shared_library('jsonxx', 'jsonxx.cc',
					cpp_args : '-w',
					install : true)

dep = declare_dependency(link_with : lib,
	include_directories : inc)

