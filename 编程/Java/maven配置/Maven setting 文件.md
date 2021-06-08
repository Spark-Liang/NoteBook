#### Maven setting 文件

- 基本配置
  
  - servers配置项
  
  - mirrors配置项
  
  - profiles配置项
  
  - 仓库相关配置



##### 基本配置

maven 的setting文件主要用于提供仓库相关的信息，包括本地仓库、中央仓库和远程仓库的信息。



setting文件主要有以下配置项：

- `localRepository`：用于配置本地仓库的路径。

- `proxies`：用于配置代理服务器。

- `servers`：用于配置登录某个服务器需要的账号密码信息。

- `mirrors`：用于配置仓库的镜像。相当于某个repository的可以访问的镜像。**注意，只有当一个镜像无法连接时才会选择下一个镜像，无法查找到包不会切换镜像查找。**

- `profiles`：用于定义各种配置项的集合。



###### servers配置项

servers 中的每个server都有两种配置方式，一种是提供用户名和密码，另一种是提供服务器的公钥和公钥密码。server中配置的登录信息是通过id匹配到对应的repository或者mirror，相当于setting中有id为abc的server和abc的mirror，则相当于id为abc的server就是为id为abc的mirror提供账号密码信息。

```xml
<servers>
<id>mirror-1</id>
<username>repouser</username>
<password>repopwd</password>
</servers>
...
<mirrors>
<id>mirror-1</id>
...
</mirrors>
```

[需要在setting文件中配置加密密码，可以参考此链接。](http://maven.apache.org/guides/mini/guide-encryption.html)



###### mirrors配置项

- mirrors用于配置指定仓库的镜像，对于同一个仓库配置多个镜像相当于repository的灾备服务器。因为**只有当一个镜像无法连接时才会选择下一个镜像，无法查找到包不会切换镜像查找。**

- 配置对同一个repository的多个镜像，优先级是从上到下依次尝试。

- 每个mirror是通过`mirrorOf`元素去指定是哪个repository的镜像。

- 每个mirror是通过`url`元素去指定镜像的url。

- `mirrorOf`参数可以放复杂的表达式，如，`repo1,repo2`，`*`或者`*,!repo1`。更多复杂表达式参考，[Maven &#x2013; Guide to Mirror Settings](http://maven.apache.org/guides/mini/guide-mirror-settings.html)。



###### profiles配置项

profiles用于全局配置一些选项需要在不同的条件下有不同的值。如需要区分dev和prod的，或者需要区分jdk版本的。<br>

主要配置项：

- `activation`：用于配置某个profile是否使用的条件。常见的条件有
  
  - `activeByDefault`：是否默认使用
  
  - `jdk`：jdk版本作为条件
  
  - `os`：操作系统相关
  
  - `property`：检测POM文件的某个property满足某个value
  
  - `file`：检测某个文件存在或者不存在。

- `properties`：配置使用该profile时，某些properties的value

- `repositories`：配置使用该profile时可以使用的repository。每个repository的配置项有
  
  - `id`：repository的id
  
  - `url`：repository的url
  
  - `releases`,` snapshots`：用于控制是否使用某个artifact的release或者snapshot版本。配置`enable`为true表示使用。
  
  - `updatePolicy`：配置repository多久更新一次文件。可选有always,daily和interval:X (X分钟)

- `plugin repositories`：同`repository`

**repositories和plugin repositories中位置越靠前，优先级越高。**


