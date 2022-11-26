### Manifest管理

- manifest子命令

- 创建Manifest

- 迁移Manifest

#### 简介

manifest子命令主要用于管理docker registry上的manifest列表文件。manifest列表文件主要用于存储当前tag在不同系统或者cpu架构下引用的镜像。

![](E:\Notebook\Personal\NoteBook\img\bbc07f46a1177b150fc53a965d6aebb290efeba0.png)

#### manifest 子命令

`docker manifest`子命令包括`inspect`,`create`,`annotate`,`push`

- inspect：
  
  - 查看某个仓库上的manifest文件信息。
  
  - 如果文件不存在会报错。
  
  - 如果仓库对应的tag是单个镜像而非manifest列表时，`mediaType`会是`application/vnd.docker.distribution.manifest.v2+json`

#### 创建Manifest

示例脚本：

```bash
docker manifest create --insecure <registry address>/flink:v1.0.0 \
      <registry address>/flink:v1.0.0-arm64 \
      <registry address>/flink:v1.0.0-amd64 \
	 
	  
docker manifest annotate <registry address>/flink:v1.0.0 \
      <registry address>/flink:v1.0.0-arm64 \
      --arch arm64 --os linux 
	  
docker manifest annotate <registry address>/flink:v1.0.0 \
      <registry address>/flink:v1.0.0-amd64 \
      --arch amd64 --os linux 
	  
docker manifest push --insecure  <registry address>/flink:v1.0.0
```
