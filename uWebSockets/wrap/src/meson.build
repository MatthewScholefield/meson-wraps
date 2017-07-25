sources = [
	'Extensions.cpp',
	'Group.cpp',
	'Networking.cpp',
	'Hub.cpp',
	'Node.cpp',
	'WebSocket.cpp',
	'HTTPSocket.cpp',
	'Socket.cpp',
	'Epoll.cpp'
]

headers = [
    'Hub.h',
    'uWS.h',
    'Asio.h',
    'Node.h',
    'Epoll.h',
    'Group.h',
    'Libuv.h',
    'Socket.h',
    'Backend.h',
    'WebSocket.h',
    'Extensions.h',
    'HTTPSocket.h',
    'Networking.h',
    'WebSocketProtocol.h'
]

lib = shared_library('uWS',
					sources,
					dependencies : deps,
					cpp_args : '-w',
					install : true)

sdir = 'uWS'
custom_install_dir = '../include/' + sdir

mkdir = find_program('mkdir')
cp = find_program('cp')

run_command(mkdir, '-p', custom_install_dir)
run_command(cp, headers, custom_install_dir)

inc = include_directories('../include')
install_headers(headers, subdir : sdir)

