##### conda 的channel管理

###### 包安装顺序

conda 安装包时，首先在一系列仓库搜索包，然后根据规则进行优先级排序(默认)：

1. 根据channel priority排序；
2. 根据version number排序；
3. 根据build number排序；
4. 选取优先级最高的包进行安装；



###### 在config中channels的相关配置

```bash
# 查看已有的 channels
conda config --get channels

# 添加 channels
conda config --add channels

# 添加新的channel到最高优先级
conda config --add channels new_channel

# 添加新的channel到最低优先级
conda config --append channels new_channel

```
