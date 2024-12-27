{smcl}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "cnsf##syntax"}{...}
{viewerjumpto "Description" "cnsf##description"}{...}
{viewerjumpto "Options" "cnsf##options"}{...}
{viewerjumpto "Remarks" "cnsf##remarks"}{...}
{viewerjumpto "Examples" "cnsf##examples"}{...}
{title:Title}

{phang}
{bf:cnsf} {hline 2} Contaminated normal-half normal stochastic frontier model


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:cnsf}
{depvar}
[{indepvars}]
{ifin}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt nopen:alty}}estimate without penalty function{p_end}
{synopt :{cmdab:lclass:(#)}}specify the number of latent classes or mixture components; default is 2{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}


{syntab:Other options}
{synopt:{opt cost}}fit cost frontier model; default is production frontier model{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}


{title:Description}

{pstd}
{cmd:cnsf} estimates a stochastic production or cost frontier model in which the noise
term follows a scale contaminated normal distribution (i.e. a mixture of two normal
distributions with zero means and different variances) and the inefficiency term
follows a half normal distribution

{title:Options}

{dlgtab:Frontier}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] estimation options}.


{dlgtab:Other options}

{phang}
{opt cost} specifies that {opt cnsf} fits a cost frontier model.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] estimation options}.


{title:Saved results}

{pstd}
{cmd:sfcross} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{title:Examples}

{cmd:import excel "https://raw.githubusercontent.com/timbulwidodostp/cnsf/main/cnsf/cnsf.xlsx", sheet("Sheet1") firstrow clear}
{cmd:cnsf beta0 beta1 beta2}

{title:Authors}

{pstd}Timbul Widodo{p_end}
{pstd}Olah Data Semarang{p_end}
{pstd}www.youtube.com/@amalsedekah{p_end}

{pstd}Alexander Stead{p_end}
{pstd}Institute for Transport Studies, University of Leeds{p_end}
{pstd}Leeds, UK{p_end}
{pstd}a.d.stead@leeds.ac.uk{p_end}

{title:Also see}

{psee}
{space 2}Help:  {help cnsf_postestimation}
{p_end}