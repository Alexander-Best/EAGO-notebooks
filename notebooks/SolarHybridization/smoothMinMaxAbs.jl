absD1(x,e) = sqrt(x^2+e)
minD1(x,y)= -0.5*(-x-y+absD1(x-y,1.0e-1))
maxD1(x,y)=-minD1(-x,-y)
absD2(x,c) = x*erf(c*x)
minD2(x,y)=-0.5*(-x-y+absD2(x-y,5))
maxD2(x,y)=-minD2(-x,-y)