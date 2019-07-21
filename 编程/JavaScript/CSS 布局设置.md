采用Flex 布局中的属性及相应的作用
---------------------------------

### 属性目录：

设置容器的属性：

- flex-direction: （设置主轴方向 ）row \| row-reverse \| column
  
  \|column-reverse

- flex-wrap:(设置元素换行方式）nowrap \| wrap \| wrap-reverse

- justify-content:(设置元素在主轴方向上的分布方式)flex-start \| flex-end \|
  
  center \|space-between \| space-around \| space-evenly

- align-items:(设置元素在交叉轴轴方向上的对齐方式) stretch \| center \|
  
  flex-end \| baseline \| flex-start

- align-content:(设置元素在交叉轴轴方向上的分布方式)stretch \| flex-start \|
  
  center \|flex-end \| space-between \| space-around \| space-evenly

设置item的属性：

- order:(item的序号)0 \| \<integer\>

- flex-shrink:（item收缩权重）1\| \<number\>

- flex-grow:（item增长权重）0 \| \<number\>

- flex-basis:（设置主轴方向上的item长度）auto \| \<length\>

- flex:（设置 shrink，grow，basis的简写）none \| auto \| \@flex-grow
  
  \@flex-shrink \@flex-basis

- align-self:（设置交叉轴的对齐方式用于覆盖container的设置）auto（默认值） \|
  
  flex-start \| flex-end \|center \| baseline\| stretch
