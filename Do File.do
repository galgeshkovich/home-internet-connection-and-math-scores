


use "pisa_2018.dta" , clear



keep if cnt=="MDA"
keep pv1math st011q06ta mmins compete st013q01ta
order pv1math st011q06ta mmins compete st013q01ta
drop if st011q06ta==.
drop if mmins==.
drop if compete==.
drop if st013q01ta==.



asdoc sum pv1math st011q06ta mmins compete st013q01ta
hist pv1math , freq
hist mmins, freq
hist compete, freq
twoway (lfit pv1math mmins)



reg pv1math ib2.st011q06ta
outreg2 using reg4.doc
reg pv1math ib2.st011q06ta mmins compete i.st013q01ta
outreg2 using reg4.doc, append 


gen math_bin=pv1math>429.3945
codebook math_bin
di 2309/4629

reg math_bin ib2.st011q06ta mmins compete i.st013q01ta
outreg2 using a2.doc

twoway (scatter math_bin mmins , jitter(7)) (lfit math_bin mmins)

logit math_bin ib2.st011q06ta mmins compete i.st013q01ta
outreg2 using b.doc

logit math_bin ib2.st011q06ta mmins compete i.st013q01ta
predict p_i, pr
gen p_ii=1-p_i
gen partial=p_i*p_ii* 1.178335
sum partial

use "pisa_2018.dta" , clear
keep if cnt=="MDA"

keep pv1math st011q06ta mmins compete st013q01ta escs gfofail

drop if st011q06ta==.
drop if mmins==.
drop if compete==.
drop if st013q01ta==.
drop if gfofail==.
drop if escs==.

reg st011q06ta escs gfofail
predict u_hat, res

reg pv1math ib2.st011q06ta mmins compete i.st013q01ta u_hat
outreg2 using d.doc

reg st011q06ta escs gfofail mmins compete i.st013q01ta
predict y_hat

ivreg pv1math (st011q06ta=y_hat) mmins compete st013q01ta
outreg2 using l.doc


