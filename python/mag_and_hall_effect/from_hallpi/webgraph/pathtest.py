
import path
import sys


import pdb;pdb.set_trace()

# directory reach
#directory = path.path(__file__).abspath()

(fpath,f) = path.os.path.split(__file__)
patharr = fpath.split('/')
npatharr = patharr[:-1]
npath = "/".join(npatharr)

sys.path.append(f"{npath}/")

# setting path
#sys.path.append(directory.parent.parent)
 
# importing
from hardware import channels


 
# using
print(channels)