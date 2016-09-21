import ROOT
import shipunit as u
def MCPointPrintOut(x):
  p = ROOT.TDatabasePDG.Instance().GetParticle(x.PdgCode())
  n=''
  if p: n = p.GetName()
  txt = '("%s") X:%6.3Fcm Y:%6.3Fcm Z:%6.3Fcm dE/dx:%6.2FMeV %s'%(\
    x.Class_Name(),x.GetX(),x.GetY(),x.GetZ(),x.GetEnergyLoss()/u.MeV,n)
  return txt
def MCTrackPrintOut(x):
  c = x.GetPdgCode()
  p = ROOT.TDatabasePDG.Instance().GetParticle(c)
  n=''
  if p: n = p.GetName()
  m = x.GetMotherId()
  txt = '("ShipMCTrack") pdgCode: %7i(%10s) P=%6.3F GeV/c mother=%i'%(c,n,x.GetP(),m)
  return txt
def FitTrackPrintOut(x):
  st = x.getFitStatus()
  if st.isFitConverged():
   chi2DoF = st.getChi2()/st.getNdf()
   sta = x.getFittedState()
   P = sta.getMomMag()
   txt = '("FitTrack") chi2/dof:%3.1F  P:%5.2FGeV/c pdg:%i'%(chi2DoF,P,sta.getPDG())
  else:
   txt = '("FitTrack") fit not converged'
  return txt
def TParticlePrintOut(x):
  txt = '("TParticle") %s  P:%5.2FGeV/c VxZ:%5.2Fm'%(x.GetName(),x.P(),x.Vz()/100.)
  return txt

def Dump(x):
  k=0
  for obj in x: 
    print k,obj.__repr__()
    k+=1 
  
def TVector3PrintOut(x):
  txt = '%9.5F,%9.5F,%9.5F'%(x.X(),x.Y(),x.Z())
  return txt

ROOT.FairMCPoint.__repr__ = MCPointPrintOut
ROOT.ShipMCTrack.__repr__ = MCTrackPrintOut
ROOT.genfit.Track.__repr__ = FitTrackPrintOut
ROOT.TClonesArray.Dump = Dump
ROOT.TVector3.__repr__ = TVector3PrintOut
ROOT.TParticle.__repr__ = TParticlePrintOut
