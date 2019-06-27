#### LogisticsRegression

逻辑回归的思路是通过一个线性模型，计算出一个值，再通过一个函数把预测值映射到 \[0,1\] 这个区间表示概率，当预测的概率大于0.5则预测为1，当预测概率小于0.5 则预测为0。<br>

在逻辑回归中把 $(- \infin,+\infin)$ 映射到 $(0,1)$ 空间的函数是： $Sigmoid(x) = \frac{1}{1+e^{-x}}$。

##### LogisticsRegression的损失函数

由于逻辑回归需要处理的是分类问题，无法很直观地通过距离来得出损失函数。**但是，我们可以用个设计一个惩罚函数，来得到损失函数。对于分类问题可以认为，当实际为1，但是模型的预测值为0，就需要惩罚。并且预测的概率越接近0，惩罚就应该越大。**<br>

对于上面的要求，就有了代价函数： $cost(p_i)=y_i\log(p_i) + (1-y)\log(1-p_i) → 当y=0, cost(p_i)=\log(1-p_i),当y=1,cost(p_i)=\log(p_i)$

有了代价函数，就可以得到损失函数，然后用梯度下降法求解最小值了。

#### scikit-learn中使用LogisticsRegression

##### scikit-learn中LogisticsRegression的正则化

在scikit-learn中引入正则化项即其比例系数是通过如下方式的：$C \cdot J(θ)+ L_1或者C \cdot J(θ)+ L_2$ 。采用该种方式的意义在于训练模型时必须使用到正则化。

##### logisticsRegression的超参数

- C ：控制模型的正则化程度。
- penalty： 模型正则化的方式，'l1'表示LASSO，'l2'表示ridge
- 和随机梯度下降法相关的超参数：
  - max\_iter: 迭代步数
  - random_state: 随机种子
  - tol: 收殓残差

在scikit-learn中LogisticsRegression是封装在 sklearn.linear_model 模块中的。所以该算法本身是一个线性模型。

```python
from sklearn.linear_model import LogisticRegression

log_reg = LogisticRegression()
log_reg.fit(X_train, y_train)
log_reg.predict(x_test)
log_reg.predict_proba(x_test) # 获得概率
```

###### scikit-learn中的LogisticsRegression默认支持多分类

```python
LogisticRegression(
    penalty='l2', # 模型正则化所使用的Lg范数，l1为LASSO，ls为Ridge

    dual=False,
    tol=0.0001,
    C=1.0, # 控制模型正则化的系数

    fit_intercept=True,
    intercept_scaling=1,
    class_weight=None,
    random_state=None,
    solver='warn', # 控制使用多分类时求解梯度的求解器

    max_iter=100,
    multi_class='warn', # 控制实现多分类的方式，可以取值为 ‘ova‘和’multinormal‘

    verbose=0,
    warm_start=False,
    n_jobs=None,
)

# 当使用 OvO 是求解器必须为 newton-cg
log_reg = LogisticsRegression(multi_class='multinormal', solver='newton-cg')
```
