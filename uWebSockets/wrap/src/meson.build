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

lib = shared_library('uWS',
					sources,
					dependencies : deps,
					cpp_args : '-w',
					install : true)
