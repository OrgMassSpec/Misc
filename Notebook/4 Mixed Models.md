# Mixed Models

References: Nesting and Mixed Effects: Part II, Meier. <https://stat.ethz.ch/~meier/teaching/anova/index.html> An Introduction to Linear Mixed-Effects Modeling in R, Brown

Linear models and linear mixed effects models in R with linguistic applications. (Winter)

## Linear Modeling

Example: Columns: 1) Individual subject ID 2) subject groups 3) data value. The linear model of $data \sim group$, or data as a function of group, has $group$ as a *fixed effect* and is the structural part of the model. Random factors include influences not included in $group$ and is represented by the error term $\epsilon$ and is the random part of the model.

$$ data \sim group + \epsilon$$

When using `lm()`, $\epsilon$ is not specified. `summary()` gives the coefficients of the fixed effects. `Multiple R-squared` is the statistic $R^2$ or the variance explained by the model with a range of 0 to 1. `Adjusted R-squared` or $R^2_{adj}$ describes the variance explained by the model, down adjusted by the number of fixed effects. The `p-value` is the probability of obtaining this data under the condition that the null hypothesis is true. The null hypothesis is the model has no effect. 

Reporting: E.g., results of `F-statistic: 46.61 on 1 and 4 DF,  p-value: 0.002407` reported as "We constructed a linear model of $data$ as a function of $group$. This model was significant (F(1,4)=46.61, p\<0.01)."

The linear model expresses categorical differences as a slope between the means of the two categories. In this example, $group$ has two categories. The two $group$ categories are selected alphabetically, with the first at $x=0$ and the second at $x=1$ of the linear model plot. The mean of the first category is the intercept, referred to as $(Intercept)$ in the `Coefficients` table. The difference between the mean of the first category and the mean of the second category is the slope, referred to as the combined term $groupcategory$ in the table. The $groupcategory$ coefficient is the slope (positive or negative). The coefficients' p-values are asking if the values are different from zero. The $groupcategory$ coefficient will have the same p-value as the overall p-value if there is only one fixed effect.

The same principle applies for continuous data. 

Multiple linear regression:

$$ data \sim group1 + group2 + ... + \epsilon$$

Assumptions
- Linearity: attempt e.g., log transformation if not linear.
- Absence of collinearity: the fixed effects are not correlated with each other.
- Homoskedasticity: check the residual plot.
- Check influencial data points. See `dfbeta()`.
- Independence: each data point comes from a subject completely independent of the others.

Mixed models add structure to the random $\epsilon$ aspect of the model, leaving the systematic fixed part unchanged.

The independence assumption is violated if there are mutiple measures per subject. Subject variation will result in a different baseline $data$ values for each subject, and can be modeled as a _random effect_, in this case a _random intercept_ for each subject. Each subject is assigened its own intercept value. Here, it is assumed the treatment effect is the same on all subjects, therefore the slope for each subject's $data$ is the same.

$$data \sim group1 + group2 + (1|subject) + \epsilon$$

The notation $(1|subject)$ says to assume the intercept is different for each subject. 

If there is an additional source of non-dependence: e.g., 

$$data \sim group1 + group2 + (1|subject) + (1|item) + \epsilon$$
