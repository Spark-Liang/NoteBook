最基本的配置是使用Spring提供的Runner<br>

![](img/Junit_Spring_Combination_1.png)



并且需要配置相应的配置文件的路径

![](img/Junit_Spring_Combination_2.png)

**通常在idea中使用test Source 文件夹标记的话才能够使用到Maven中"\<scope\>\</scope\>"标记为test的jar包**

**此外对应的包名尽量与main文件夹中相同，这样在可以比较方便地在TestCase中使用spring的ioc**
