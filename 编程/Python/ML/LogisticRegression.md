##### scikit-learn中使用LogisticsRegression

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
