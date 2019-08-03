" black.vim
" Author: Łukasz Langa
" Created: Mon Mar 26 23:27:53 2018 -0700
" Requires: Vim Ver7.0+
" Version:  1.1
"
" Documentation:
"   This plugin formats Python files.
"
" History:
"  1.0:
"    - initial version
"  1.1:
"    - restore cursor/window position after formatting
"
" Source: https://raw.githubusercontent.com/psf/black/master/plugin/black.vim

if v:version < 700 || !has('python3')
    echo "This script requires vim7.0+ with Python 3.6 support."
    finish
endif

if exists("g:load_black")
   finish
endif

let g:load_black = "py1.0"
if !exists("g:black_virtualenv")
  let g:black_virtualenv = "~/.venv/black"
endif
if !exists("g:black_fast")
  let g:black_fast = 0
endif
if !exists("g:black_linelength")
  let g:black_linelength = 88
endif
if !exists("g:black_skip_string_normalization")
  let g:black_skip_string_normalization = 0
endif

python3 << endpython3
import glob
import os
import sys
import vim

def _get_python_binary(exec_prefix):
  try:
    default = vim.eval("g:pymode_python").strip()
  except vim.error:
    default = ""
  if default and os.path.exists(default):
    return default
  if sys.platform[:3] == "win":
    return exec_prefix / 'python.exe'
  return exec_prefix / 'bin' / 'python3'

def _get_pip(venv_path):
  if sys.platform[:3] == "win":
    return venv_path / 'Scripts' / 'pip.exe'
  return venv_path / 'bin' / 'pip'

def _get_virtualenv_site_packages(venv_path, pyver):
  if sys.platform[:3] == "win":
    return venv_path / 'Lib' / 'site-packages'
  return os.path.join(glob.glob(os.path.join(venv_path, 'lib', f'python{pyver[0]}.*'))[0], 'site-packages')

def _initialize_black_env(upgrade=False):
  pyver = sys.version_info[:2]
  if pyver < (3, 6):
    print("Sorry, Black requires Python 3.6+ to run.")
    return False

  from pathlib import Path
  import subprocess
  import venv
  virtualenv_path = Path(vim.eval("g:black_virtualenv")).expanduser()
  virtualenv_site_packages = str(_get_virtualenv_site_packages(virtualenv_path, pyver))
  if not virtualenv_path.is_dir():
    print(f'No virtualenv at {virtualenv_path}')
    return False
  if upgrade:
    print('Upgrading Black with pip...')
    subprocess.run([str(_get_pip(virtualenv_path)), 'install', '-U', 'black'], stdout=subprocess.PIPE)
    print('DONE! You are all set, thanks for waiting ✨ �� ✨')
  if sys.path[0] != virtualenv_site_packages:
    sys.path.insert(0, virtualenv_site_packages)
  return True

def Black():
  # Lazy load this on first run to avoid installing black when
  # it's not wanted, eg: when someone spreads their
  # vim rc wide from a git repo or NFS home dir.
  if _initialize_black_env():
    import black
    import time
  else:
    print('Failed to initialized venv')
    sys.exit(1)

  start = time.time()
  fast = bool(int(vim.eval("g:black_fast")))
  mode = black.FileMode(
    line_length=int(vim.eval("g:black_linelength")),
    string_normalization=not bool(int(vim.eval("g:black_skip_string_normalization"))),
    is_pyi=vim.current.buffer.name.endswith('.pyi'),
  )
  buffer_str = '\n'.join(vim.current.buffer) + '\n'
  try:
    new_buffer_str = black.format_file_contents(buffer_str, fast=fast, mode=mode)
  except black.NothingChanged:
    print(f'Already well formatted, good job. (took {time.time() - start:.4f}s)')
  except Exception as exc:
    print(exc)
  else:
    cursor = vim.current.window.cursor
    vim.current.buffer[:] = new_buffer_str.split('\n')[:-1]
    try:
      vim.current.window.cursor = cursor
    except vim.error:
      vim.current.window.cursor = (len(vim.current.buffer), 0)
    print(f'Reformatted in {time.time() - start:.4f}s.')

def BlackUpgrade():
  _initialize_black_env(upgrade=True)

def BlackVersion():
  if _initialize_black_env():
    import black
    print(f'Black, version {black.__version__} on Python {sys.version}.')
  else:
    print('Failed to initialized venv')

endpython3

command! Black :py3 Black()
command! BlackUpgrade :py3 BlackUpgrade()
command! BlackVersion :py3 BlackVersion()

