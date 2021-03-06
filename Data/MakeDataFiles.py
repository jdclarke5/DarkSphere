
import pylab
import pyPLUTO as pp
import string
import numpy

# Write only every Sk cells
Sk = 8;

for Mach100 in range(74,178):
	D = pp.pload(Mach100,datatype='hdf5',level=4)
	# Write rho,prs,vx1,vx2,bx1,bx2 to file
        Mach = Mach100/100.
	filename = string.join( ('rhoM','{0:.2f}'.format(Mach),'.dbl') , sep='' )    
        D.rho[0::Sk,0::Sk].transpose().tofile(filename)
	filename = string.join( ('prsM','{0:.2f}'.format(Mach),'.dbl') , sep='' )    
	D.prs[0::Sk,0::Sk].transpose().tofile(filename)
	filename = string.join( ('vx1M','{0:.2f}'.format(Mach),'.dbl') , sep='' ) 
	D.vx1[0::Sk,0::Sk].transpose().tofile(filename)
	filename = string.join( ('vx2M','{0:.2f}'.format(Mach),'.dbl') , sep='' )    
	D.vx2[0::Sk,0::Sk].transpose().tofile(filename)
	filename = string.join( ('bx1M','{0:.2f}'.format(Mach),'.dbl') , sep='' )    
	D.bx1[0::Sk,0::Sk].transpose().tofile(filename)
	filename = string.join( ('bx2M','{0:.2f}'.format(Mach),'.dbl') , sep='' )    
	D.bx2[0::Sk,0::Sk].transpose().tofile(filename)

