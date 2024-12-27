//Contaminated normal-half normal stochastic frontier model
//Coded by Alex Stead
//Institute for Transport Studies, University of Leeds
//Email: a.d.stead@leeds.ac.uk

//This programme enables the estimation of a stochastic frontier model in which
//the noise term follows a contaminated normal distribution (i.e. a mixture of
//normals) and the inefficiency term follows a half normal distribution.

program cnsf, eclass
	version 13.1 
	if !replay() {
		syntax varlist(numeric fv ts) [if] [in] [, Level(cilevel) LCLASS(integer 2) COST PRODuction NOPENalty]
		local s								=	-1
		local pen							=	0
		if "`cost'"=="" local s						=	1
		if "`nopenalty'"=="" {
			local pen						=	1
			local crittype							crittype("log modified likelihood")
		}
		global cost_s `s'
		global pen `pen'
		global class_num `lclass'
		marksample touse
		gettoken yvar xvars : varlist
		local mlmodel_list /lnsigma_v1
		forval i = 2/`lclass' {
			local mlmodel_list `mlmodel_list' /lnsigma_v`i'
		}
		local probs 							=	`lclass'-1
		forval i = 1/`probs' {
			local mlmodel_list `mlmodel_list' /logprob`i'
		}
		local eqlist lnsigma_v1
		local funclist exp([lnsigma_v1]_cons)
		local probfunc 1
		local derlist `funclist'
		local diparm_list diparm(`eqlist', exp label(sigma_v1) prob) 
		forval i = 2/`lclass' {
			local eqlist `eqlist' lnsigma_v`i'
			local problist `problist' logprob`=`i'-1'
			local funclist `funclist'+exp([lnsigma_v`i']_cons)
			local probfunc `probfunc'-invlogit([logprob`=`i'-1']_cons)
			local derlist `derlist' exp([lnsigma_v`i']_cons)
			local probder `probder' -invlogit([logprob`=`i'-1']_cons)/(1+exp([logprob`=`i'-1']_cons))
			local diparm_list `diparm_list' diparm(`eqlist', func(`funclist') der(`derlist') label(sigma_v`i') prob)
		}
		forval i = 1/`probs' {
			local diparm_list `diparm_list' diparm(logprob`i', invlogit label(prob`i') prob)
		}
		quietly{
			frontier `yvar' `xvars', `cost' d(h)
			local b_cons						=	_b[_cons]
			local lnsigma_v1					=	ln(e(sigma_v))+ln(0.5)
			forval i = 2/`lclass' {
				local lnsigma_v`i'				=	ln(`lclass'/`i')
			}
			forval i = 1/`probs'  {
				local logprob`i'				=	-ln(1/(1/2)^`i'-1)
			}
			local lnsigma_u						=	ln(e(sigma_u))
			foreach x in `xvars'{
				local b_`x'					=	_b[`x']
			}
		}
		ml model d1 cnsf_ll (mu:`yvar'=`xvars') /lnsigma_u `mlmodel_list', `crittype' title(Stoch. frontier contaminated normal/half normal model) diparm(lnsigma_u, exp label(sigma_u) prob) `diparm_list' diparm(`problist', func(`probfunc') der(`probder') label(prob`lclass') prob)		
		quietly {
			foreach x in `xvars'{
				ml init mu:`x'					=	`b_`x''
			}
			ml init mu:_cons					=	`b_cons'
			local mlinit_list /lnsigma_v1				=	`lnsigma_v1'
			forval i = 2/`lclass' {
				local mlinit_list `mlinit_list' /lnsigma_v`i'	=	`lnsigma_v`i''
			}
			forval i = 1/`probs' {
				local mlinit_list `mlinit_list' /logprob`i'	=	`logprob`i''
			}
			ml init /lnsigma_u					=	`lnsigma_u' `mlinit_list'
		}
	}
	ereturn clear
	ml search
	ml maximize
	tempname b V y ll ic converged
	matrix `b'								=	e(b)
	matrix `V'								=	e(V)
	scalar `ic'								=	e(ic)
	scalar `ll'								=	e(ll)
	scalar `converged'							=	e(converged)
	ereturn post `b' `V', esample(`touse')
	ereturn scalar ic							=	`ic'
	ereturn scalar ll							=	`ll'
	ereturn scalar converged						=	`converged'
	ereturn local predict "cnsf_p"
	ereturn local cmd "cnsf"
	global ML_y1 `yvar'
end
