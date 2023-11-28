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

## Splines Implementation

Any _d-th_-order spline $f(\cdot)$ is a piecewise polynomial function of degree $d$ that is continuous and has continuous derivatives of orders $1, \ldots, d - 1$ at the so-called **knot points**. To build a generic dth-order spline $f(\cdot)$, we start from a bunch of points, say $q$, that we call knots $\xi_1 < \xi_2 < \cdots < \xi_q$, and we then ask the following:
1. $f(\cdot)$ is some polynomial of degree $d$ on each of the intervals: $(-\infty, \xi_1], [\xi_1, \xi_2], [\xi_2, \xi_3], \ldots, [\xi_q, +\infty)$;
2. its _j-th_ derivative $f^{(j)}(\cdot)$ is continuous at $\xi_1, \ldots, \xi_q$ for each $j \in \{0, 1, \ldots, d - 1\}$.

Given a set of points $\xi_1 < \xi_2 < \cdots < \xi_q$, there is a quick-and-dirty way to describe/generate the whole set of _d-th_-order spline functions over those $q$ knots:

* Start from **truncated power functions** $G_{d,q} = \{ g_1(x), \ldots, g_{d+1}(x), g_{(d+1)+1}(x), \ldots, g_{(d+1)+q}(x) \}$, defined as: $\{ g_1(x) = 1, g_2(x) = x, \ldots, g_{d+1}(x) = x^d \}$, $\{ g_{(d+1)+j}(x) = (x - \xi_j)_{+}^d \}$ for $j = 1$ to $q$, where $(x) _{+} = max(0, x)$.
* Then, if $f(\cdot)$ is a _d-th_-order spline with knots $\{\xi_1, \ldots, \xi_q\}$, you can show it can be obtained as a linear combination over $G_{d,q}$:

    **$f(x) = \sum_{j=1}^{(d+1)+q} \beta_j g_j(x)$,** for some set of coefficients $\beta = [\beta_1, \ldots, \beta_{d+1}, \beta_{(d+1)+1}, \ldots, \beta_{(d+1)+q}]^T$

## Nested Cross Validation

Considering the knots as positioned on q-equispaced locations, we proceed with different Cross Validation techniques to tune the hyperparameters (knots, maximum degree of the truncated power functions, etc.) such as: **Grid Search CV**, **Vanilla CV**, and the **Nested CV** from the [Bates et al.](https://arxiv.org/pdf/2104.00673.pdf) article.
We used **Repeated CV** to find the best degree and number of knots.



Degree          |  Knots
:-------------------------:|:-------------------------:
<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/3956ec48-d611-40b1-ba85-c8d88dce0ff9"> | <img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/1aeb886d-b5d2-4d78-a1df-dc47e7f52218">


Then we implemented an **Elastic Net regularization** and tuned the related hyperparameters always with the CV.

Shrinkage type          |  Shrinkage weight
:-------------------------:|:-------------------------:
<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/11c3aa4e-7be1-4982-9e91-4fa9d39599eb"> | <img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/69e03137-cdd9-46f7-825b-45d0ce4edeea">

<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/9b06869a-6ab2-4fa6-acc1-a52f8fb3f15a" align="center">

## Fit the splines

Finally we can fit the obtained splines to our WMAP data.

<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/213730f2-fd6f-4b4b-80da-748a5f3af970" width=100% height=70%>

## Final results
Due to the _Heteroschedaticity_ of our train data our predictions may be affected by the big noise of the training data in the final part of the shape. We use the Box-Cox transformation.

<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/24926e6f-9985-46c8-b852-65b69930a77a" width=100% height=60%>

Then we fit another time the splines and obtain our final results!

<img src="https://github.com/Engrima18/CosmicSplines/assets/93355495/6bef1fcc-717c-43bc-b61b-d2a9b6b7ddea">




## Team ("🍫I Cioccolatosi🍫"): 
- Enrico Grimaldi ([Linkedin](https://www.linkedin.com/in/enrico-grimaldi18/) - [Github](https://github.com/Engrima18))
- Giuseppe Di Poce ([Linkedin](https://www.linkedin.com/in/giuseppe-di-poce-82a4ba14a/) - [Github](https://github.com/))
- Davide Vigneri ([Linkedin](https://www.linkedin.com/in/davide-vigneri-59a56021a/) - [Github](https://github.com/giuseppedipoce))
- Nicola Grieco ([Linkedin](https://www.linkedin.com/in/nicola-grieco-36a993233/) - [Github](https://github.com/nicolagrieco00))

## Used technologies
 
![RStudio](https://img.shields.io/badge/RStudio-4285F4?style=for-the-badge&logo=rstudio&logoColor=white)
![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)

