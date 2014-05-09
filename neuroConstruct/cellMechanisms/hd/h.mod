TITLE I-h channel from Magee 1998 for distal dendrites

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)

}

PARAMETER {
      v (mV)
      ehd  =-34	(mV)        
      celsius = 33 	(degC)
      gmax = %Max Conductance Density% 	(mho/cm2)
      vhalfl=-81   	(mV)
      kl=-8
      vhalft=-75   	(mV)
      a0t=0.011      	(/ms)
      zetat=2.2    	(1)
      gmt=.4   	(1)
      q10=4.5
      qtl=1
      tau=1
}


NEURON {
	SUFFIX %Name%
	NONSPECIFIC_CURRENT i
        RANGE gmax, vhalfl,tau
        GLOBAL linf,taul
}

STATE {
        l
}

ASSIGNED {
	i (mA/cm2)
        linf      
        taul
        ghd
}

INITIAL {
	rate(v)
	l=linf
}


BREAKPOINT {
	SOLVE states METHOD cnexp
	ghd = gmax*l
	i = ghd*(v-ehd)

}


FUNCTION alpt(v(mV)) {
  alpt = exp(0.0378*zetat*(v-vhalft)) 
}

FUNCTION bett(v(mV)) {
  bett = exp(0.0378*zetat*gmt*(v-vhalft)) 
}

DERIVATIVE states {     : exact when v held constant; integrates over dt step
        rate(v)
        l' =  (linf - l)/taul
}

PROCEDURE rate(v (mV)) { :callable from hoc
        LOCAL a,qt
        qt=q10^((celsius-33)/10)
        a = alpt(v)
        linf = 1/(1 + exp(-(v-vhalfl)/kl))
        :       linf = 1/(1+ alpl(v))
        taul = tau*bett(v)/(qtl*qt*a0t*(1+a))
}













