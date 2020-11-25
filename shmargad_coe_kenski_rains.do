// Before running the replication code, 
// install reghdfe and ftools using the following commands:
// ssc install reghdfe
// ssc install ftools

// Models of subsequent incivility

use "shmargad_coe_kenski_rains.dta", clear

// Remove singletons
keep if last_uncivil != . & uncivil_after_last != . & incivility != . & last_down != . & last_up != .
egen x = count(comment), by(a)
egen y = count(comment), by(id)
keep if x > 1 & y > 1

// Estimate models
meglm incivility i.uncivil_after_last##(c.last_down c.last_up) c.gap c.r if last_uncivil == 0 || a: || id:, family(bernoulli) vce(robust)
meglm incivility i.uncivil_after_last##(c.last_down c.last_up) c.gap c.r if last_uncivil == 1 || a: || id:, family(bernoulli) vce(robust)

meglm incivility i.last_uncivil##i.uncivil_after_last##(c.last_down c.last_up) c.gap c.r || a: || id:, family(bernoulli) vce(robust)

margins, dydx(uncivil_after_last) over(last_uncivil) at(last_down=(0 25 50 75)) predict(mu fixedonly)
marginsplot, by(last_uncivil) yline(0) saving(last_down_re)

margins, dydx(uncivil_after_last) over(last_uncivil) at(last_up=(0 25 50 75)) predict(mu fixedonly)
marginsplot, by(last_uncivil) yline(0) saving(last_up_re)

reghdfe incivility i.last_uncivil##i.uncivil_after_last##(c.last_down c.last_up) c.gap c.r, absorb(a id) vce(robust)

margins, dydx(uncivil_after_last) over(last_uncivil) at(last_down=(0 25 50 75))
marginsplot, by(last_uncivil) yline(0) saving(last_down)

margins, dydx(uncivil_after_last) over(last_uncivil) at(last_up=(0 25 50 75))
marginsplot, by(last_uncivil) yline(0) saving(last_up)

// Models of community feedback

use "shmargad_coe_kenski_rains.dta", clear

// Remove singletons
keep if last_uncivil != . & uncivil_after_last != . & incivility != . & down != . & up != .
egen x = count(comment), by(a)
egen y = count(comment), by(id)
keep if x > 1 & y > 1

// Estimate models
meglm down i.uncivil_after_last##i.incivility c.up c.gap c.r if last_uncivil == 0 || a: || id:, family(nbinomial) vce(robust)
meglm down i.uncivil_after_last##i.incivility c.up c.gap c.r if last_uncivil == 1 || a: || id:, family(nbinomial) vce(robust)

meglm up i.uncivil_after_last##i.incivility c.down c.gap c.r if last_uncivil == 0 || a: || id:, family(nbinomial) vce(robust)
meglm up i.uncivil_after_last##i.incivility c.down c.gap c.r if last_uncivil == 1 || a: || id:, family(nbinomial) vce(robust)

meglm down i.last_uncivil##i.uncivil_after_last##i.incivility c.up c.gap c.r || a: || id:, family(nbinomial) vce(robust)

margins, dydx(incivility) over(uncivil_after_last last_uncivil) predict(mu fixedonly)
marginsplot, by(last_uncivil) yline(0) saving(down_re)

meglm up i.last_uncivil##i.uncivil_after_last##i.incivility c.down c.gap c.r || a: || id:, family(nbinomial) vce(robust)

margins, dydx(incivility) over(uncivil_after_last last_uncivil) predict(mu fixedonly)
marginsplot, by(last_uncivil) yline(0) saving(up_re)

reghdfe down i.last_uncivil##i.uncivil_after_last##i.incivility c.up c.gap c.r, absorb(a id) vce(robust)

margins, dydx(incivility) over(uncivil_after_last last_uncivil)
marginsplot, by(last_uncivil) yline(0) saving(down)

reghdfe up i.last_uncivil##i.uncivil_after_last##i.incivility c.down c.gap c.r, absorb(a id) vce(robust)

margins, dydx(incivility) over(uncivil_after_last last_uncivil)
marginsplot, by(last_uncivil) yline(0) saving(up)
