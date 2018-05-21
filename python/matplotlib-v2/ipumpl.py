from __future__ import print_function

import os
from contextlib import contextmanager

import matplotlib.pyplot as plt
from matplotlib.style.core import USER_LIBRARY_PATHS
from matplotlib.colors import LinearSegmentedColormap
import matplotlib.cm as mplcm

import shutil


@contextmanager
def temp_style_file(name):
    """ A context manager for creating an empty style file in the expected path.
    """
    stylelib_path = USER_LIBRARY_PATHS[0]
    if not os.path.exists(stylelib_path):
        os.makedirs(stylelib_path)

    srcname = os.path.abspath(name)
    dstname = os.path.join(stylelib_path, name)
    if not os.path.exists(srcname):
        raise RuntimeError('Cannot use file at "' + srcname + '". This file does not exist.')
    if os.path.exists(dstname):
        raise RuntimeError('Cannot create a temporary file at "' + dstname + '". This file exists already.')
    
    #with open(filename, 'w'):
    #    pass
    
    shutil.copy2(srcname, dstname)
    
    
    rgb = [
      (  0./255. ,   0./255. ,   0./255.),     
      (  0./255. , 102./255. ,  51./255.),
      #(114./255. , 121./255. , 126./255.),
      ( 91./255. , 172./255. ,  38./255.),
      (217./255. , 220./255. , 222./255.),
      (255./255. , 255./255. , 255./255.)
      ]

    # create map and register it together with reversed colours
    maps = []
    maps.append(LinearSegmentedColormap.from_list('IPU'  , rgb))
    maps.append(LinearSegmentedColormap.from_list('IPU_r', rgb[::-1]))

    for cmap in maps:
        mplcm.register_cmap(cmap=cmap)
        #self._color_maps[cmap.name] = cmap
    
    yield
    os.remove(dstname)



#print('# styles available:', len(plt.style.available))
#
#with temp_style_file('dummy.mplstyle'):
#    print('# before reload:', len(plt.style.available))
#
#    plt.style.reload_library()
#    print('# after reload:', len(plt.style.available))