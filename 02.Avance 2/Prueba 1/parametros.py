from unidades import *

# PROPIEDADES DE MATERIALES Y SECCIONES
# fc = 210*kgf/cm**2
# E = 15100*(fc/(kgf/cm**2))**0.5*kgf/cm**2
# G = 0.5*E/(1+0.2)

fy = 4200*kgf/cm**2  # Fluencia del acero
Es = 2.1*10**6*kgf/cm**2  # Módulo de elasticidad del acero
fc = 210  # kg/cm2             #Resistencia a la compresión del concreto
E = 15100*fc**0.5*kgf/cm**2  # Módulo de elasticidad del concreto
G = 0.5*E/(1+0.2)  # Módulo de corte del concreto
fc = fc*kgf/cm**2
cover = 4*cm  # Recubrimiento de vigas y columnas

# Parametros no lineales de comportamiento del concreto
fc1 = -fc  # Resistencia a la compresión del concreto
Ec1 = E  # Módulo de elasticidad del concreto
nuc1 = 0.2  # Coeficiente de Poisson
Gc1 = Ec1/(2*(1+nuc1))  # Módulo de corte del concreto

# Concreto confinado
Kfc = 1.0  # 1.3               # ratio of confined to unconfined concrete strength
Kres = 0.2                    # ratio of residual/ultimate to maximum stress
fpc1 = Kfc*fc1
epsc01 = 2*fpc1/Ec1
fpcu1 = Kres*fpc1
epsU1 = 5*epsc01  # 20
lambda1 = 0.1
# Concreto no confinado
fpc2 = fc1
epsc02 = -0.003
fpcu2 = Kres*fpc2
epsU2 = -0.006  # -0.01
# Propiedades de resistencia a la tracción
ft1 = -0.14*fpc1
ft2 = -0.14*fpc2
Ets = ft2/0.002
#print(E/10**8, Ets/10**8)

# Densidad del concreto
ρ = 2400*kg/m**3


def prop_vig(bv, hv):

    Av = bv*hv
    ρlv = 2400*Av*m**2  # Densidad lineal de la viga
    Izv = hv**3*bv/12
    Iyv = hv*bv**3/12
    k = 1/3-0.21*bv/hv*(1-(bv/hv)**4/12)
    Jv = k*bv**3*hv
    return Av, ρlv, Izv, Iyv, k, Jv


def prop_col(bc, hc):

    Ac = bc*hc
    ρlc = 2400*Ac*m**2 	# Densidad lineal de la columna
    Izc = hc**3*bc/12
    Iyc = hc*bc**3/12
    k = 1/3-0.21*bc/hc*(1-(bc/hc)**4/12)
    Jc = k*bc**3*hc
    return Ac, ρlc, Izc, Iyc, k, Jc


# Aplicando Cargas vivas y muertas
wLive = 250*kg/m**2
wLosa = 300*kg/m**2
wAcab = 100*kg/m**2
wTabi = 150*kg/m**2
wTotal = 1.0*(wLosa+wAcab+wTabi)+0.25*wLive

aPlanta = 321