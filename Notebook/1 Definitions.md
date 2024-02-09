# Definitions

Compiled from Field, Andy; Miles, Jeremy; Field, Zoe. Discovering Statistics Using R. SAGE Publications. Kindle Edition.

## Sample
Data collected from the subset of a population.

## Mean
The mean is a simple statistical model.

$$\bar{X} = \frac{\sum_{i=1}^{n}x_i}{n}$$

## Standard error 
Several samples from the same population will differ due to sampling variation. The sampling distribution consists of the sample means as a frequency distribution. The standard deviation of the sample means is the standard error of the mean (SE). The central limit theorem states for sample numbers \> 30, the sampling distribution is normal with a mean equal to the population mean and a standard deviation of

$$\sigma_{\bar{x}} = s/\sqrt N$$

This equation approximates the standard error. For sample numbers \< 30 the sampling distribution has a different shape, the t-distribution.

## Degrees of freedom (df)
Related to the number of observations that are free to vary. E.g. if a sample mean is 10, it is assumed the population mean is also 10. With this parameter fixed, only n - 1 of the scores can vary. The nth score must be fixed to keep the mean constant.

## Variables
### Independent variable
Causes the effect (aka predictor variable); its value does not depend on any other variable. 
### Dependent variable
The effect (aka outcome variable); it depends on the independent variable. 
### Categorical variable
Distinct entities (categories). Binary: two categories. Nominal: numbers represent category names. Ordinal: ordered nominal data. 
### Continuous variable 
Numeric value on a measurement scale. Interval: a scale with equal intervals between possible values. Ratio: ratio of values is meaningful (scale has a zero point). Discrete: only certain allowed variables in the scale. 
### Confounding variable 
A variable other than the predictor that may affect the outcome.

## Correlational or cross-sectional 
Research is observational without manipulation. In experimental research, the variable(s) is manipulated, and its effect measured.

## Model and Error
Outcome data can be predicted from the **model and error**. Model goodness of fit can be assessed by the deviation.

$$outcome_i = model + error_i$$ 

$$deviation = \sum(observed - model)^2$$

## Variance and Standard Deviation
The fit of the mean as a model: Deviance is the difference between the data and the model at an independent (x-axis) variable value (i.e., the error in the model prediction at that point). In the case of the mean as the model of the data set, the **deviance** is $x_i - \bar{x}$, where $x_i$ is a data point, and $\bar{x}$ is the mean of the data set. The total error is then the sum of the deviance, $\sum(x_i - \bar{x})$. But, with this method the total negative and positive deviance of the data set cancel. To prevent this, use the sum of squared errors (SS) where $SS = \sum(x_i - \bar{x})^2$, but this value will be dependent upon the number of data points. Therefore the **variance** ($s^2$) is used, where N is the number of observations. $s^2 = \frac{SS}{N-1} = \frac{\sum(x_i - \bar{x})^2}{N - 1}.$ The variance is in units squared since each deviance is squared. To return to the original units, use the **standard deviation** ($s$).

$$s = \sqrt{\frac{\sum(x_i - \bar{x})^2}{N - 1}}.$$

## Standard Error of the Mean

**The standard error of the mean (SE)** is the standard deviation of sample means. It represents how well a sample (draw) represents the population. Draws from a population will have a sampling variance. These sampling means have a frequency distribution aka **sampling distribution**. The sampling distribution is the frequency distribution of sample means, and is represented by the SE. For n \> 30, the **central limit theorem** states that

$$SE = \frac{s}{\sqrt{N}}$$

(approximate). For n \< 30 the sampling distribution is approximated by the t-distribution.

## Confidence Intervals

Confidence intervals are estimated boundaries within which the true mean is likely to fall. If 95% confidence intervals of two samples do not overlap, we can infer the two means are from different populations. The standard error is $SE=s/\sqrt N$. Values of z-scores between -1.96 to 1.96 contain 95% of the scores. The central limit theorem states the standard deviation of the sample means (i.e., the standard error) will be normally distributed. For large samples of n \> 30:

$$1.96 = \frac{x-\bar{x}}{SE} \Rightarrow x = (1.96 \times SE) + \bar{x}$$

The mean is the center of the confidence interval:

-   Lower bound of the 95% confidence interval = $\bar{x} - (1.96 \times SE)$

-   Upper bound of the 95% confidence interval = $\bar{x} + (1.96 \times SE)$

Generally, where p is the probability value of the confidence interval:

-   Lower bound of confidence interval = $\bar{x} - (z_\frac{1-p}{2} \times SE)$

-   Upper bound of confidence interval = $\bar{x} + (z_\frac{1-p}{2} \times SE)$

The probability is split in half and on both ends of the distribution. 

## Boxplot

Box covers 50% of the data, i.e., through the 1st, 2nd, and 3rd quartile. The whisker is 1.5 times the interquartile range of the 1st quartile to the 3rd quartile. Max of $Q3+1.5 \times IQR$ and min $Q1-1.5 \times IQR$. Outside the whiskers are extreme values.   

See: `mean()`, `median()`, `sd()`, `range()`, and `quantile()`.

