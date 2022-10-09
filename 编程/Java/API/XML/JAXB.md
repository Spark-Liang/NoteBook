### JAXB

- 常用注解
  
  - 类级别注解
  
  - 字段级别注解

- 与xml转化的示例

- 常见问题解决
  
  - 循环依赖解决

#### 常用注解

##### 类级别

###### `@XmlRootElement`

定义了该类映射的xml根节点，可配置name和namespace选项，对应xml节点的name和namespace。

注意点：

- **常与`@XmlType`，`@XmlAccessorType`，`@XmlAccessorOrder`连用。**

- 一个xml文件只能有一个根节点。

###### `@XmlType`

定义转化成xml后的属性的顺序，或者直接配置bean和xml转化的工厂类和工厂方法。可配置属性有：

- name，namespace：配置xml元素的名称和命名空间，需要与`@XmlRootElement`对应

- propOrder：配置属性的顺序。
  
  - 对于`@XmlElementWrapper`标注的属性，不能出现在`@XmlType`的propOrder列表中。
  
  - 对于所有`@XmlElement`标注过的属性，必须出现在`@XmlType`的propOrder列表中。

- factoryClass：配置工厂类的

- factoryMethod：配置使用工厂类的工厂方法

用法：

- 配置`@XmlRootElement`和`@XmlType`，则`@XmlType`主要用于控制属性顺序

- 只配置`@XmlType`，常用于配置一些值对象类型到xml的映射，但是该值对象类型不能作为根节点。

###### `@XmlAccessOrder`

也是类级别控制生成的xml的元素的顺序的注解。可选值有两个

- `XmlAccessOrder.ALPHABETICAL`：按照字段的字母表顺序排序。

- `XmlAccessOrder.UNDEFINED`（默认值）：按照字段定义的顺序排序。**只有在XmlAccessorType是FIeld时才起作用。**

###### `@XmlAccessorType`

控制扫描需要转化的属性的方式，可选有：

- `XmlAccessType.PROPERTY`：
  
  - 自动转化所有有getter和setter的属性
  
  - 在一个字段有set/get方法对但又在字段上添加@XmlElement注解**会报属性重复的错误。**
  
  - 若没有set/get方法对，则需要在字段上使用@XmlElement注解才可以映射为xml元素
  
  - 若get/set方法上使用了@XmlTransient注解，但想要对应字段发生映射，需要在对应字段上添加@XmlElement注解

- `XmlAccessType.FIELD`: 自动抓所有非static字段，除非标注`@XmlTransient`

- `XmlAccessType.PUBLIC_MEMBER`（默认）:自动映射public字段
  
  - **不可同时**存在public字段和对应的get/set方法对，不然**会报属性重复的错误。**
  
  - 使用@XmlElement注解，需要注意只能在字段或get/set方法添加，两者任选其一，否则**会报属性重复的错误。**

- `XmlAccessType.NONE`：不映射任何字段，除非加上`@XmlElement`注解

##### 字段级别

###### `@XmlElement`

把字段映射成子xml元素。

###### `@XmlAttribute`

把字段映射成根xml的属性。

###### `@XmlValue`

定义映射到xml节点文本的字段。使用了该注解后，其他字段必须使用`@XmlAttribute`进行映射。

`@XmlJavaTypeAdapter`

控制复杂类型的转化。需要配置转化类的类型。
