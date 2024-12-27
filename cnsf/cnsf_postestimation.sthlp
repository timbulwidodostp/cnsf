{smcl}
{cmd:help cnsf postestimation} {...}
{right:also see:  {help cnsf}}
{hline}

{title:Title}

{p2colset 5 32 38 2}{...}
{p2col :{hi:cnsf postestimation} {hline 2}}Postestimation tools for
cnsf{p_end}
{p2colreset}{...}


{title:Description}

{pstd}
The following postestimation commands are available for {opt cnsf}:

{synoptset 11}{...}
{p2coldent :command}description{p_end}
{synoptline}
{synopt :{helpb cnsf postestimation##predict:predict}}predictions, residuals,
efficiency scores, conditional probabilities{p_end}
{synoptline}
{p2colreset}{...}


{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]

{synoptset 15 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt bc}}estimates of (technical or cost) inefficiency via {it:E}[exp(-u)|e]
(Battese and Coelli., 1988){p_end}
{synopt :{opt jlms}}estimates of (technical or cost) inefficiency via exp[-{it:E}(u|e)]
(Jondrow et al., 1982){p_end}
{synopt :{opt jlms1}}estimates of (technical or cost) inefficiency via exp[-{it:E}(u|e)]
(Jondrow et al., 1982), for the first class{p_end}
{synopt :{opt jlms2}}estimates of (technical or cost) inefficiency via exp[-{it:E}(u|e)]
(Jondrow et al., 1982), for the second class{p_end}
{synopt :{opt jlms[i>2]}}estimates of (technical or cost) inefficiency via exp[-{it:E}(u|e)]
(Jondrow et al., 1982), for the [i]th class; only when lclass>2{p_end}
{synopt :{opt cprob1}}conditional probabilities of belong to the first class{p_end}
{synopt :{opt cprob2}}conditional probabilities of belong to the second class{p_end}
{synopt :{opt cprob[i>2]}}conditional probabilities of belong to the [i]th class; only when lclass>2{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}


{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt residuals}, calculates the residuals.

{phang}
{opt bc} produces estimates of (technical or cost) efficiency via E[exp(-u)|e]. 

{phang}
{opt jlms} produces estimates of (technical or cost) efficiency via exp[-E(u|e)]. 

{phang}
{opt jlms1} produces estimates of (technical or cost) efficiency via exp[-E(u|e)]
 for the first class.

{phang}
{opt jlms2} produces estimates of (technical or cost) efficiency via exp[-E(u|e)]
 for the second class.

{phang}
{opt jlms2} produces estimates of (technical or cost) efficiency via exp[-E(u|e)]
 for the second class.

{phang}
{opt jlms2} produces estimates of (technical or cost) efficiency via exp[-E(u|e)]
 for the second class.

{phang}
{opt jlms[i>2]} produces estimates of (technical or cost) efficiency via exp[-E(u|e)]
 for the [i]th class; only when lclass>2.

{phang}
{opt cprob1} produces estimates of conditional probabilities of belonging to the
 first class. 

{phang}
{opt cprob2} produces estimates of conditional probabilities of belonging to the
 second class.

{phang}
{opt cprob[i>2]} produces estimates of conditional probabilities of belonging to the
 [i]th class; only when lclass>2. 


{title:Authors}

{pstd}Alexander Stead{p_end}
{pstd}Institute for Transport Studies, University of Leeds{p_end}
{pstd}Leeds, UK{p_end}
{pstd}a.d.stead@leeds.ac.uk{p_end}


{title:Also see}

{psee}
{space 2}Help:  {help cnsf}
{p_end}
