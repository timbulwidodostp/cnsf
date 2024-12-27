program cnsf_ll
		local lclass				=	$class_num
		local probs				=	`lclass'-1
		local tempvar_list lnsigma_v1
		forval i				=	2/`lclass' {
		local tempvar_list `tempvar_list' lnsigma_v`i'
		local sigma_v`i' `sigma_v`=`i'-1'' + exp(`lnsigma_v`i'')
		}
forval i				=	1/`probs' {
		local tempvar_list `tempvar_list' logprob`i'
		}
		local eq_no				=	2
		version 13.1
		args todo b lnf g
		tempvar mu lnsigma_u `tempvar_list' fj
		local sigma_v1 exp(`lnsigma_v1')
		forval i				=	2/`lclass' {
		local sigma_v`i' `sigma_v`=`i'-1'' + exp(`lnsigma_v`i'')
		}
 		mleval `mu'				= 	`b',		eq(1)
		mleval `lnsigma_u' 			= 	`b',		eq(2)		
		forval i				=	1/`lclass' {
		local eq_no				=	`eq_no'+1
		mleval `lnsigma_v`i''			=	`b',		eq(`eq_no')	scalar
		}
		forval i				=	1/`probs' {
		local eq_no				=	`eq_no'+1
		mleval `logprob`i''			=	`b',		eq(`eq_no')	scalar
		}
		quietly {
				local s			=	$cost_s
				local fj_list exp(`logprob1')/(1+exp(`logprob1'))*2/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2))*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v1'))/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2))
				local sum_probs		=	exp(`logprob1')/(1+exp(`logprob1'))
				local prod_probs	=	exp(`logprob1')/(1+exp(`logprob1'))
				forval i		=	2/`probs' {
				local fj_list `fj_list'+exp(`logprob`i'')/(1+exp(`logprob`i''))*2/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))
				local sum_probs		=	`sum_probs'+exp(`logprob`i'')/(1+exp(`logprob`i''))
				local prod_probs	=	`prod_probs'*exp(`logprob`i'')/(1+exp(`logprob`i''))
				}
				gen double `fj'		=	`fj_list'+ln(1-`sum_probs')/ln(1-`sum_probs')*(1-`sum_probs')*2/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))
				mlsum `lnf'		=	ln(`fj')
				if $pen			==	1{
				scalar `lnf'		=	`lnf'+1*ln(`lclass'^`lclass'*`prod_probs'*(1-`sum_probs'))
				}
				}
if(`todo'==0 | `lnf'>=.) exit
		forval i				=	1/`eq_no' {
		local tempname_list `tempname_list' d`i'
		}
		tempname `tempname_list'
		local d1_list 1/`fj'*(exp(`logprob1')/(1+exp(`logprob1'))*2/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')/((`sigma_v1')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v1'))/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2))+`s'*(exp(`lnsigma_u')/(`sigma_v1'))/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2)*normalden(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v1'))/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2)))
		local d2_list exp(`lnsigma_u')/`fj'*2*(exp(`logprob1')/(1+exp(`logprob1'))*1/((`sigma_v1')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2))*(exp(`lnsigma_u')/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v1'))/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v1')^2+exp(`lnsigma_u')^2)-1)-`s'*($ML_y1-`mu')*(`sigma_v1')/((`sigma_v1')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v1'))/sqrt((`sigma_v1')^2+exp(`lnsigma_u')^2)))
		forval i				=	2/`probs' {
		local d1_list `d1_list'+exp(`logprob`i'')/(1+exp(`logprob`i''))*2/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))+`s'*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)))
		local d2_list `d2_list'+exp(`logprob`i'')/(1+exp(`logprob`i''))*1/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*(exp(`lnsigma_u')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)-1)-`s'*($ML_y1-`mu')*(`sigma_v`i'')/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)))
		}
		mlvecsum `lnf' `d1'			=	`d1_list'+(1-`sum_probs')*2/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))+`s'*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)))), eq(1)
		mlvecsum `lnf' `d2'			=	`d2_list'+(1-`sum_probs')*1/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*(exp(`lnsigma_u')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)-1)-`s'*($ML_y1-`mu')*(`sigma_v`lclass'')/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)))), eq(2)
		local der`lclass' 1/`fj'*1/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*2*(1-`sum_probs')*normalden(($ML_y1-`mu')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*((`sigma_v`lclass'')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)-1)+`s'*($ML_y1-`mu')*exp(`lnsigma_u')*(2+(exp(`lnsigma_u')/(`sigma_v`lclass''))^2)/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)))
		forval i				=	`=`lclass'-1'(-1)1 {
		local der`i' 1/`fj'*1/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*2*exp(`logprob`i'')/(1+exp(`logprob`i''))*normalden(($ML_y1-`mu')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*((`sigma_v`i'')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)-1)+`s'*($ML_y1-`mu')*exp(`lnsigma_u')*(2+(exp(`lnsigma_u')/(`sigma_v`i''))^2)/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)))+`der`=`i'+1''
		}
		forval i				=	1/`lclass' {
		mlvecsum `lnf' `d`=`i'+2''		=	exp(`lnsigma_v`i'')*(`der`i''), eq(`=`i'+2')
		}
		/*forval i				=	1/`probs' {
		mlvecsum `lnf' `d`=`i'+2''		=	exp(`lnsigma_v`i'')/`fj'*1/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*2*exp(`logprob`i'')/(1+exp(`logprob`i''))*normalden(($ML_y1-`mu')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*((`sigma_v`i'')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)-1)+`s'*($ML_y1-`mu')*exp(`lnsigma_u')*(2+(exp(`lnsigma_u')/(`sigma_v`i''))^2)/((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))) ///
								+ exp(`lnsigma_v`i'')/`fj'*1/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*2*(1-`sum_probs')*normalden(($ML_y1-`mu')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*((`sigma_v`lclass'')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)-1)+`s'*($ML_y1-`mu')*exp(`lnsigma_u')*(2+(exp(`lnsigma_u')/(`sigma_v`lclass''))^2)/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))), eq(`=`i'+2')
		}
		mlvecsum `lnf' `d`=`lclass'+2''		=	exp(`lnsigma_v`lclass'')/`fj'*1/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*2*(1-`sum_probs')*normalden(($ML_y1-`mu')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*((`sigma_v`lclass'')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*(($ML_y1-`mu')^2/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)-1)+`s'*($ML_y1-`mu')*exp(`lnsigma_u')*(2+(exp(`lnsigma_u')/(`sigma_v`lclass''))^2)/((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))), eq(`=`lclass'+2')
		*/
		forval i				=	1/`probs' {
		mlvecsum `lnf' `d`=`lclass'+`i'+2''	=	exp(`logprob`i'')/(1+exp(`logprob`i''))^2*1/`fj'*(2/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`i''))/sqrt((`sigma_v`i'')^2+exp(`lnsigma_u')^2))-2/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2)*normalden(($ML_y1-`mu')/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))*normal(-`s'*($ML_y1-`mu')*(exp(`lnsigma_u')/(`sigma_v`lclass''))/sqrt((`sigma_v`lclass'')^2+exp(`lnsigma_u')^2))), eq(`=`lclass'+`i'+2')
		if $pen					==	1{
		matrix `d`=`lclass'+`i'+2''		=	`d`=`lclass'+`i'+2''+J(1,`=colsof(`d`=`lclass'+`i'+2'')',1*exp(`logprob`i'')/(1+exp(`logprob`i''))^2*((1+exp(`logprob`i''))/exp(`logprob`i'')-1/(1-`sum_probs')))
		}
		}
		local g_list `d1'
		forval i				=	2/`eq_no' {
		local g_list `g_list',`d`i''
		}
		matrix `g' = (`g_list')
end
