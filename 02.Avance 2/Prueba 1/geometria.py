import pickle

a = "ops_data.sav"
with open(a, 'rb') as f:
    data = pickle.load(f)
Nodes, Elems, Diap, Vig, Col, Mx, My, nsec_vig, nsec_col, Rest= data["Nodes"], data["Elems"], data["Diap"], data["Vig"], data["Col"], data["Mx"], data["My"], data["nsec_vig"], data["nsec_col"], data["Rest"]

nz = len(Diap)
dz = Diap[1][3] - Diap[0][3]