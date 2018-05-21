from __future__ import print_function

import os
from contextlib import contextmanager

import matplotlib.pyplot as plt
from matplotlib.style.core import USER_LIBRARY_PATHS


@contextmanager
def temp_style_file(name):
    """ A context manager for creating an empty style file in the expected path.
    """
    stylelib_path = USER_LIBRARY_PATHS[0]
    if not os.path.exists(stylelib_path):
        os.makedirs(stylelib_path)

    filename = os.path.join(stylelib_path, name)
    if os.path.exists(filename):
        raise RuntimeError('Cannot create a temporary file at "' + filename + '". This file exists already.')
    
    with open(filename, 'w'):
        pass
    yield
    os.remove(filename)



#print('# styles available:', len(plt.style.available))
#
#with temp_style_file('dummy.mplstyle'):
#    print('# before reload:', len(plt.style.available))
#
#    plt.style.reload_library()
#    print('# after reload:', len(plt.style.available))