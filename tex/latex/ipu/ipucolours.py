# -*- coding: utf-8 -*-
from __future__ import print_function, division, absolute_import
import matplotlib as mpl
import matplotlib.cm as mplcm
from cycler import cycler 
import numpy as np
from matplotlib.colors import LinearSegmentedColormap
#import brewer2mpl
from itertools import cycle
import platform

def _get_color_map():
    """A function to create and register the custom colour map objects 
    in a way matplotlib can digest. The cubehelix (including Kindl et al., 
    the Brewer3 colour maps (YlOrRd, PuBuGn, YlGnBu) all provide proper 
    desaturation in grey-scale.
    
    """
    specs = {}
    # We start out with the custom cubehelix maps
    #========= =======================================================
    #Keyword Description
    #========= =======================================================
    #gamma     gamma factor to emphasise either low intensity values
    #          (gamma < 1), or high intensity values (gamma > 1);
    #          defaults to 1.0.
    #s         the start color; defaults to 0.5 (i.e. purple).
    #r         the number of r,g,b rotations in color that are made
    #          from the start to the end of the color scheme; defaults
    #          to -1.5 (i.e. -> B -> G -> R -> B).
    #h         the hue parameter which controls how saturated the
    #          colors are. If this parameter is zero then the color
    #          scheme is purely a greyscale; defaults to 1.0.
    #========= =======================================================
    # 0 = blue, 1 = red, 2 = green
    specs['cubehelix_alt']   = mpl._cm.cubehelix(h=1.5) # standard colours but more intensity
    specs['cubehelix_blue']  = mpl._cm.cubehelix(s=0.3,r=-0.5,h=1.5) # blue colours and higher intensity
    specs['cubehelix_red']   = mpl._cm.cubehelix(s=1.3,r=-0.5,h=1.5) # blue colours and higher intensity
    specs['cubehelix_green'] = mpl._cm.cubehelix(s=2.3,r=-0.5,h=1.5) # blue colours and higher intensity
    specs['cubehelix_kindl'] = mpl._cm.cubehelix(gamma=1.4,s=0.4,r=-0.8,h=2.0) # blue colours and higher intensity
    
    for name in specs:
        mplcm.register_cmap(name=name, data=specs[name])
        mplcm.register_cmap(name=name+"_r", data=mplcm._reverse_cmap_spec(specs[name]))
    #    #self._color_maps[name] = self.get_color_map(name)
    #    #self._color_maps[name+"_r"] = self.get_color_map(name+"_r")
    return mplcm.get_cmap('cubehelix_kindl')


def _get_color_list(length=None):
    if length is None: length = 4
    cmap  = _get_color_map()
    clist = [cmap(i) for i in np.linspace(0.25, 0.75, length)]
    return clist

if __name__ == "__main__":
    clist = _get_color_list()
    print(clist)
    #for i in dic:
    #    line_fig,map_fig,sur_fig = dic[i]()._show_info()
    #    line_fig.savefig(i+"_lines.pdf")
    #    map_fig.savefig(i+"_maps.pdf")
    #    sur_fig.savefig(i+"_surf.pdf")
