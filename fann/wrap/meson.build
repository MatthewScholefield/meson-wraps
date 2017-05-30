project('fann', ['c', 'cpp'])

add_project_arguments('-fopenmp', language: ['c', 'cpp'])
add_project_link_arguments('-lgomp', '-lm', language: ['c', 'cpp'])

subdir('src')

dep = declare_dependency(link_with : lib,
	include_directories : inc)
	
pkg_mod = import('pkgconfig')
pkg_mod.generate(libraries : lib,
				 version : '2.2.0',
				 name : 'libfann',
				 filebase : 'fann',
				 description : 'Fast Artificial Neural Network Library')

