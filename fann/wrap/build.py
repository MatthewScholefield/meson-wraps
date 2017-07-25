#!/usr/bin/env python3

from fabricate import *
from os import listdir, chdir
from subprocess import call
import sys

find_files = lambda d, ext: [d + '/' + i for i in listdir(d) if ext in i]

prefix = '/usr/local'
for i in sys.argv:
    if i.startswith('--prefix='):
        prefix = i.replace('--prefix=', '')
        print('Using prefix: ' + prefix)

def run_untracked(args):
    print(', '.join(args))
    call(args)

def build():
    run('cc', '-fPIC', '-c', 'src/floatfann.c', '-Isrc/include')
    
    after(); run('cc', '-shared', '-o', 'libfann.so', '-lm', find_files('.', '.o'))
    after(); run('mkdir', '-p', 'include/fann')
    after(); run('cp', find_files('src/include', '.h'), 'include/fann')

def install():
    build(); after()
    run_untracked(['mkdir', '-p', prefix + '/include'])
    run_untracked(['mkdir', '-p', prefix + '/lib'])
    run_untracked(['cp', '-rf', 'include/fann', prefix + '/include/fann'])
    run_untracked(['cp', '-rf', 'libfann.so', prefix + '/lib/libfann.so'])

def uninstall():
    clean(); after()
    run_untracked(['rm', '-rf', prefix + '/include/fann'])
    run_untracked(['rm', '-rf', prefix + '/lib/libfann.so'])

def clean():
    autoclean()

main(parallel_ok=True, jobs=3)  
