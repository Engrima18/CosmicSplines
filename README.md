# CosmicSplines
Implementation of Regression Splines from scratch to predict  e cosmic microwave background (CMB) angular power spectrum.
1-st Homework for the course of "Statistical learning" at La Sapienza University of Rome ([Kaggle competition link](https://www.kaggle.com/competitions/statistical-learning-warm-up-hw01-2023))

## Brief description
We are talking about a snapshot of our universe in its infancy,
something like 379,000 years after the Big Bang, nothing compared to the estimated age of our universe.

<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/e10207f8-8b2e-4d7b-bab6-3407237e53e0" align="right">

The map next was taken by the Wilkinson Microwave Anisotropy Probe (WMAP) and shows differences across the sky in
the temperature of the cosmic microwave background (CMB), the radiant heat remaining from the Big Bang. The average
temperature is 2.73 degrees above absolute zero but the temperature is not constant across the sky. The fluctuations in the
temperature map provide information about the early universe. Indeed, as the universe expanded, there was a tug of war
between the force of expansion and contraction due to gravity. This caused acoustic waves in the hot gas, which is why there
are temperature fluctuations.
The strength of the temperature fluctuations f(x) at each frequency (or multipole) x is called the power spectrum and
this power spectrum can be used by cosmologists to answer cosmological questions. For example, the relative abundance
of different constituents of the universe (such as baryons and dark matter) corresponds to peaks in the power spectrum.
 the temperature map can be reduced to the following scatterplot of
power versus frequency:

<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/e7dd3e4d-66d3-4abd-92a5-d2c160a20836" width=70% height=70% align="center">

## Goal
In a nutshell:

>- The dataset in training consists of 675 CMB angular power spectrum observations estimated from the latest WMAP data release.
>- The goal is to predict the angular power spectrum at 224 additional frequencies.
>- RMSE is the adopted metric.

## Splines implementation
Any _d-th_-order spline $f(·)$ is a piecewise polynomial function of degree d that is continuous and has
continuous derivatives of orders ${1, . . . , d − 1}$ at the so called **knot points**. To build a generic dth-order
spline f(·) we start from a bunch of points, say $q$, that we call knots $ξ_1 < · · · < ξ_q$, and we then ask the following:
1. $f(·)$ is some polynomial of degree $d$ on each of the intervals: $(−∞, ξ_1], [ξ_1, ξ_2], [ξ_2, ξ_3], . . . , [ξ_q, +∞)$;
2. its _j-th_ derivative $f_j(·)$ is continuous at ${ξ_1, . . . , ξ_q}$ for each $j \in {0, 1, . . . , d − 1}$.

Given a set of points $ξ_1 < ξ_2 < · · · < ξ_q$, there is a quick-and-dirty way to describe/generate the whole set of _d-th_-order spline functions over those $q$ knots: 

* start from **truncated
power functions** $G_{d,q}$ = { $g_1(x), . . . g_{d+1}(x), g_{(d+1)+1}(x), . . . , g_{(d+1)+q}(x)$ }, defined as: { $g_1(x) = 1, g_2(x) = x, . . . , g_{d+1}(x) = x^d$  }, { $ g_{(d+1)+j}(x) = (x − ξ_j)_{+}^d $ } for $ j=1 $ to $ q $, where $(x)_{+}$ = max{ $0, x$ }.
* Then, if $f(·)$ is a _d-th_-order spline with knots ${ξ1, . . . , ξq}$ you can show it can be obtained as a linear combinations over $G_{d,q}$:

** $f(x) = \sum_{j=1}^{(d+1)+q}  \beta_j g_j(x)$ , for some set of coefficients $\beta = \beta_1, ... , \beta_{d+1}, \beta_{(d+1)+1} , ..., \beta_{(d+1)+q} ]^T$

## Team ("🍫I Cioccolatosi🍫"): 
- Enrico Grimaldi ([Linkedin](https://www.linkedin.com/in/enrico-grimaldi18/) - [Github](https://github.com/Engrima18))
- Giuseppe Di Poce ([Linkedin](https://www.linkedin.com/in/giuseppe-di-poce-82a4ba14a/) - [Github](https://github.com/))
- Davide Vigneri ([Linkedin](https://www.linkedin.com/in/davide-vigneri-59a56021a/) - [Github](https://github.com/giuseppedipoce))
- Nicola Grieco ([Linkedin](https://www.linkedin.com/in/nicola-grieco-36a993233/) - [Github](https://github.com/nicolagrieco00))


