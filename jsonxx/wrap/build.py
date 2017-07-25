#!/usr/bin/env python3

from fabricate import *
from subprocess import call
import sys

prefix = '/usr/local'
for i in sys.argv:
    if i.startswith('--prefix='):
        prefix = i.replace('--prefix=', '')
        print('Using prefix: ' + prefix)

def run_untracked(args):
    print(' '.join(args))
    call(args)

def build():
    run('g++', '-fPIC', '-c', 'jsonxx.cc')
    run('g++', '-shared', '-o', 'libjsonxx.so', 'jsonxx.o')
    
def install():
    build()
    run_untracked(['mkdir', '-p', prefix + '/include'])
    run_untracked(['mkdir', '-p', prefix + '/lib'])
    run_untracked(['cp', '-rf', 'jsonxx.h', prefix + '/include/jsonxx.h'])
    run_untracked(['cp', '-rf', 'libjsonxx.so', prefix + '/lib/libjsonxx.so'])

def uninstall():
    clean()
    run_untracked(['rm', '-rf', prefix + '/include/jsonxx.h'])
    run_untracked(['rm', '-rf', prefix + '/lib/libjsonxx.so'])

def clean():
    autoclean()

main()
