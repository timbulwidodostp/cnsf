program cnsf_p
	version 13.1
	local lclass				=	$class_num
	local probs				=	`lclass'-1
	local opts_list JLMS1
	forval i				=	2/`lclass' {
		local opts_list `opts_list' JLMS`i'
		local nopts_list `nopts_list' `jlms`i''
	}
	forval i = 1/`probs' {
		local opts_list `opts_list' CProb`i'
		local nopts_list `nopts_list' `cprob`i''
	}
	syntax newvarname [in] [if], [JLMS BC `opts_list' Residuals]
	local nopts_list `jlms1'
	forval i = 2/`lclass' {
		local nopts_list `nopts_list' `jlms`i''
	}
	forval i = 1/`probs' {
		local nopts_list `nopts_list' `cprob`i''
	}
	local nopts : word count `jlms' `bc' `nopts_list' `residuals' `xb'
	marksample touse, novarlist
	if `nopts' > 1{
		display "{err}only one statistic may be specified"
		exit 498
	}
	local s $cost_s
	local tempvar_list u1
	forval i = 2/`lclass' {
		local tempvar_list `tempvar_list' u`i'
	}
	forval i = 1/`lclass' {
		local tempvar_list `tempvar_list' exp_u`i'
	}
	forval i = 1/`lclass' {
		local tempvar_list `tempvar_list' sv`i'
	}
	forval i = 1/`probs' {
		local tempvar_list `tempvar_list' prob`i'
	}
	forval i = 1/`lclass' {
		local tempvar_list `tempvar_list' c_prob`i'
	}
	forval i = 1/`lclass' {
		local tempvar_list `tempvar_list' f`i'
	}
	tempvar resid xb_ su u_weighted exp_u_weighted `tempvar_list' f
	tempname b
	matrix `b'				=	e(b)
	matrix score `xb_'			=	`b'
	gen `typlist' `resid'			=	$ML_y1-`xb_' 		if `touse'
	scalar `su'				=	exp([lnsigma_u]_cons)
	forval i				=	1/`lclass' {
		local add_sv`i'			=	exp([lnsigma_v`i']_cons)
		if `i' > 1 {
			local add_sv`i'		=	`add_sv`=`i'-1'' + `add_sv`i''
		}
		else local add_sv`i'		=	`add_sv`i''
		scalar `sv`i''			=	`add_sv`i''
		gen `typlist' `u`i''		=	(`sv`i''*`su')/sqrt(`sv`i''^2+`su'^2)*(normalden(`resid'*(`su'/`sv`i'')/sqrt(`sv`i''^2+`su'^2))/normal(-`s'*`resid'*(`su'/`sv`i'')/sqrt(`sv`i''^2+`su'^2))-`s'*`resid'*(`su'/`sv`i'')/sqrt(`sv`i''^2+`su'^2)) if `touse'
		gen `typlist' `exp_u`i''	=	(1-normal((`su')*(`sv`i'')/sqrt((`sv`i'')^2+(`su')^2)+`s'*(`resid')*(`su')/(`sv`i'')/sqrt((`sv`i'')^2+(`su')^2)))/(1-normal(`s'*(`resid')*(`su')/(`sv`i'')/sqrt((`sv`i'')^2+(`su')^2)))*exp(`s'*(`resid')*((`su')/sqrt((`sv`i'')^2+(`su')^2))^2+1/2*((`su')*(`sv`i'')/sqrt((`sv`i'')^2+(`su')^2))^2)
	}
	forval i				=	1/`probs' {
		scalar `prob`i''		=	invlogit([logprob`i']_cons)
		gen `typlist' `f`i''		=	 `prob`i''*2/sqrt(`sv`i''^2+`su'^2)*normalden(`resid'/sqrt(`sv`i''^2+`su'^2))*normal(-`s'*`resid'*(`su'/`sv`i'')/sqrt(`sv`i''^2+`su'^2))
	}
	local sum_probs				=	`prob1'
	gen `typlist' `f'			=	`f1'
	forval i				=	2/`probs' {
		qui replace `f'			=	`f'+`f`i''
		local sum_probs			=	`sum_probs'+`prob`i''
	}
	local prob`lclass'			=	1-`sum_probs'
	gen `typlist' `f`lclass''		=	(1-`sum_probs')*`prob`lclass''*2/sqrt(`sv`lclass''^2+`su'^2)*normalden(`resid'/sqrt(`sv`lclass''^2+`su'^2))*normal(-`s'*`resid'*(`su'/`sv`lclass'')/sqrt(`sv`lclass''^2+`su'^2))
	qui replace `f'				=	`f'+`f`lclass''
	gen `typlist' `c_prob`lclass''		=	1
	forval i				=	1/`probs' {
		gen `typlist' `c_prob`i''	=	`f`i''/`f'
		qui replace `c_prob`lclass''	=	`c_prob`lclass''-`c_prob`i''	
	}
	gen `typlist' `u_weighted'		=	`c_prob1'*`u1'
	gen `typlist' `exp_u_weighted'		=	`c_prob1'*`exp_u1'
	forval i				=	2/`lclass' {
		qui replace `u_weighted'	=	`u_weighted'+`c_prob`i''*`u`i''
		qui replace `exp_u_weighted'	=	`exp_u_weighted'+`c_prob`i''*`exp_u`i''
	}
	if `nopts' == 0{
		gen `typlist' `varlist'		=	`xb_'			if `touse'
	}
	if "`jlms'" != ""{
		gen `typlist' `varlist'		=	exp(-`u_weighted')	if `touse'
	}
	if "`bc'" != ""{
		gen `typlist' `varlist'		=	`exp_u_weighted'	if `touse'
	}
	if "`residuals'" != ""{
		gen `typlist' `varlist'		=	`resid'			if `touse'
	}
	if "`xb'" != ""{
		gen `typlist' `varlist' 	=	`xb_'			if `touse'
	}
	forval i = 1/`lclass' {
		if "`jlms`i''" != ""{
			gen `typlist' `varlist'	=	exp(-`u`i'')		if `touse'
		}
		if "`cprob`i''" != ""{
			gen `typlist' `varlist'	=	`c_prob`i''		if `touse'
		}
	}
end
