#!/usr/bin/env python3

from fabricate import *
from subprocess import call
from os import listdir, chdir
import sys

find_files = lambda d, ext: [d + '/' + i for i in listdir(d) if ext in i]

prefix = '/usr/local'
for i in sys.argv:
    if i.startswith('--prefix='):
        prefix = i.replace('--prefix=', '')
        print('Using prefix: ' + prefix)

def run_untracked(args):
    print(' '.join(args))
    call(args)

def build():
    for i in find_files('src', '.cpp'):
        run('g++', '-fPIC', '-std=c++11', '-c', i, '-Isrc/include')
    
    after(); run('g++', '-shared', '-o', 'libuWS.so', find_files('.', '.o'))
    after(); run('mkdir', '-p', 'include/uWS')
    after(); run('cp', '-r', find_files('src', '.h'), 'include/uWS')

def install():
    build(); after()
    run_untracked(['mkdir', '-p', prefix + '/include'])
    run_untracked(['mkdir', '-p', prefix + '/lib'])
    run_untracked(['cp', '-rf', 'include/uWS', prefix + '/include/uWS'])
    run_untracked(['cp', '-rf', 'libuWS.so', prefix + '/lib/libuWS.so'])

def uninstall():
    clean(); after()
    run_untracked(['rm', '-rf', prefix + '/include/uWS'])
    run_untracked(['rm', '-rf', prefix + '/lib/libuWS.so'])

def clean():
    autoclean()

main(parallel_ok=True, jobs=3)
