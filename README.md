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
Any dth-order spline $f(·)$ is a piecewise polynomial function of degree d that is continuous and has
continuous derivatives of orders ${1, . . . , d − 1}$ at the so called knot points. To build a generic dth-order
spline f(·) we start from a bunch of points, say $q$, that we call knots $ξ_1 < · · · < ξ_q$, and we then ask the following:
1. $f(·)$ is some polynomial of degree d on each of the intervals: $(−∞, ξ_1], [ξ_1, ξ_2], [ξ_2, ξ_3], . . . , [ξ_q, +∞)$;
2. its jth derivative $f_j(·)$ is continuous at ${ξ_1, . . . , ξ_q}$ for each $j \in {0, 1, . . . , d − 1}$.


