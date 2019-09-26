function PTCmodel(dni,tz,lat,long)
  include("solarAngles.jl")
  #=============================================================================
  This model takes in the DNI data and geographic location information and
  calculates the thermal power generated by the array (per m^2 aperture)
  # Written by: M. D. Stuber, May 17, 2018, rev. May 15, 2019 (Julia 1.0)
  # This code is used in the paper: Stuber (2018), DOI: 10.3390/pr6070076
  INPUTS
    dni: the DNI data vector (probably 8760 data points)
    tz: the time-zone for the location
    lat: the latitude of the location
    long: the longitude of the location
  OUTPUTS
    QabsA: thermal power (per m^2 aperture) absorbed/deployable
  =============================================================================#
  r = 0.935 # mirror reflectance
  gct = 0.963 # glass cover transmittance
  abs = 0.96 # absorptance of receiver
  intF = 1 # intercept factor
  ra = 90 # rim angle [deg]
  apertureL = 6 # aperture length [m]
  mirrorL = 109.333 # mirror length [m]
  es = 0.98 # heat collector shadowing error factor
  et = 0.994 # tracking error factor
  eg = 0.98 # geometry error factor
  el = 0.96 # general losses error factor
  er = 0.88 # mirror reflectivity
  ed = er/r # dirt on mirror error factor
  edh = (1+ed)/2 # dirt on heat collector error factor

  absOD = 0.05 # outer-diameter of absorber tube [m]
  focalD = apertureL/(4*tan(ra/2*pi/180)) # focal distance [m]
  cr = apertureL/(pi*absOD) # concentration ratio
  apertureA = apertureL*mirrorL #aperture area [m^2]


  t = range(1,stop=length(dni),length=length(dni)) # time vector
  inc=ones(length(dni)) # initialize incidence angle vector
  sun = zeros(length(dni)) # is the sun up?
  # calculate the incidence angles for the desired location
  for i = 1:length(t) # loop over all times
    inc[i] = solarAngles(t[i],tz,lat,long) # get incidence angles at this time
    if dni[i]<0 inc[i]=0 end # reset to no-sun condition if dni data is negative
  end
  # area losses
  #=
  lossA = tan.(inc*pi/180)*(2/3*apertureL*focalD+apertureL*
                            focalD*(apertureL^2/(48*focalD^2)))
  =#
  # optical efficiency
  optEff = (cos.(inc*pi/180)+8.84E-4*inc*pi/180-5.369E-5*(inc*pi/180).^2)*
    es*et*eg*ed*edh*el*r*gct
  QabsA = optEff.*dni*abs # W/m2 absorbed power density
  return QabsA
end;
