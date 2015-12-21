
import pylab
import pyPLUTO as pp
import string

for N in range(74,178):
	D = pp.pload(N,datatype='hdf5',level=4)
	I = pp.Image()
	I.pldisplay(D, D.rho, x1=D.x1, x2=D.x2, cbar=(True,'vertical'), polar=[True,True])
	figname = string.join( ('Plot',str(N),'.png') )
	pylab.savefig(figname)
        pylab.close()

