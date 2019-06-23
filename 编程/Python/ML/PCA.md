#### PCA

##### 注意事项：

- 在使用PCA 之前不能对训练数据进行归一化处理。
  - 因为PCA 本身的目标函数就是“求一个函数各个样本点投影到主成分向量之后的距离最大”，归一化会改变每个样本点投影到主成分向量的距离。举个极端的例子，当其中某一个特征就是噪声时，归一化之后会把噪声的影响放大到和其他正常特征一样的数量级。

##### 在scikit-learn中的使用方式

scikit-learn把PCA 算法封装在了 sklearn.decomposition 模块中的 PCA 类中。

```python
# 引入 PCA 
from sklearn.decomposition import PCA

pca = PCA() # 构造一个计算出训练数据所有主成分向量的PCA实例
pca = PCA(n_components=10) # 构造一个计算出前10个主成分向量的PCA实例
pca = PCA(0.95) # 构造一个PCA实例，由算法自动计算出能反映训练数据前95%的距离方差的主成分向量矩阵。

pca.fit(X_train) # 分析训练数据
X_reduction = pca.transform(X_train) # 把训练数据映射成低维度的数据
X_restore = pca.invert_transform(X_reduction) # 把降维后的数据重新还原为高维数据，但是还原出的数据已经损失掉部分信息。
```
