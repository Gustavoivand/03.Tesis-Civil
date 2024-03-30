import openseespy.opensees as ops
import itertools
import numpy as np
from numpy import pi
from numpy import linspace
import pandas as pd
my_list=[]
z1=linspace(1,10,10)
t1=linspace(4.e-3,10.e-3,10)
for z,t in itertools.product(z1,t1):
    ops.wipe()
    ops.model("basic","-ndm",2,"-ndf",2)
    #node(tag,x,y)
    ops.node(1,0,0)
    ops.node(2,1,0)
    ops.node(3,1,z)
    #fix(tag,libex,liby) libre=0, restr=1
    ops.fix(1,1,1)
    ops.fix(2,0,1)
    secTag_Circular=1
    E=200.e9
    phi = 400.e-3
    #t=4.e-3
    Iz=0.0
    A=pi*(phi/2)**2 - pi*(phi/2-t)**2
    ops.section('Elastic', secTag_Circular,E,A,Iz)
    ops.element("TrussSection",1,1,2,secTag_Circular)
    ops.element("TrussSection",2,2,3,secTag_Circular)
    ops.element("TrussSection",3,1,3,secTag_Circular)
    #time series
    ts_tag=1
    ops.timeSeries('Constant', ts_tag,'-factor',1.0)
    #load pattern
    patternTag=1
    ops.pattern('Plain', patternTag,ts_tag,'-fact',1.0)
    #cargas
    fx=0
    fy=-10e3
    ops.load(3,fx,fy)
    # ------------------------------
    # Start of analysis generation
    # ------------------------------

    # create SOE
    ops.system("BandSPD")

    # create DOF number
    ops.numberer("RCM")

    # create constraint handler
    ops.constraints("Plain")

    # create integrator
    ops.integrator("LoadControl", 1.0)

    # create algorithm
    ops.algorithm("Linear")

    # create analysis object
    ops.analysis("Static")

    # perform the analysis
    ops.analyze(1)
    d1 = ops.nodeDisp(3)
    this_list=[d1[0],z,t]
    my_list.append(this_list)

for punto in my_list:
    print(punto)

np.savetxt("dataset.csv",my_list,delimiter=",")
file =pd.read_csv("dataset.csv")
headerList=['D','z','t']
file.to_csv("dataset.csv",header=headerList,index=False)