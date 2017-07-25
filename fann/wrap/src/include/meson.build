headers = [
	'config.h',
	'doublefann.h',
	'fann.h',
	'fann_activation.h',
	'fann_cascade.h',
	'fann_cpp.h',
	'fann_data.h',
	'fann_data_cpp.h',
	'fann_error.h',
	'fann_internal.h',
	'fann_io.h',
	'fann_train.h',
	'fann_training_data_cpp.h',
	'fixedfann.h',
	'floatfann.h',
	'parallel_fann.h',
	'parallel_fann.hpp'
]

sdir = 'fann'
custom_install_dir = '../../include/' + sdir

mkdir = find_program('mkdir')
cp = find_program('cp')

run_command(mkdir, '-p', custom_install_dir)
run_command(cp, headers, custom_install_dir)

inc = include_directories(['.', '../../include'])

install_headers(headers, subdir : sdir)

