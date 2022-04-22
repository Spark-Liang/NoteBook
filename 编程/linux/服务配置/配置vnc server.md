#### 环境要求

- 安装"GNOME Desktop" "Graphical Administration Tools", 因为 vnc server需要图形界面作为后端

- 配置 vnc-server端

##### 配置过程

1. 安装Cnetos7图形界面

```bash
yum groupinstall "GNOME" "Graphical Administration Tools"
```

2. 安装和配置 vnc-server 端

```bash
# 安装
yum install tigervnc-server -y
# 配置 
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service

# 修改配置文件 /etc/systemd/system/vncserver@:1.service
# 把配置文件中的 <USER> 替换成对应的用户，需要注意的是 root 用户的home目录是 /root

# 重新加载配置文件
systemctl daemon-reload
```

3. 配置 vnc 登录密码

```bash
vncpasswd
```

4. 配置使用图形界面

```bash
# 使用 init 切换
init 5 # 切换到图形界面
init 1 # 切换回命令行界面

# 使用 systemctl 切换
systemctl set-default graphical.target # 切换到图形界面
systemctl set-default multi-user.target # 切换到命令行界面
```

##### 其他配置

###### 配置中文界面

1. 安装汉语选项
   
   ```bash
   yum install kde-l10n-Chinese
   # 检查是否安装
   yum list installed |grep glibc
   ```

2. 修改配置文件`/etc/locale.conf`
   
   ```bash
   # 修改成
   LANG="zh_CN.UTF-8"
   ```

3. 安装中文字体
   
   ```bash
   # 看字体相关的安装项
   yum list|grep fonts |grep chinese
   # 安装显示的安装项
   ```

4. 重启系统

##### 使用客户端进行连接

#### 错误处理

##### 1.配置正常但是无法启动 vnc server，或者启动成功后立即被kill掉

出现这种原因有可能是因为没有安装 GNOME。
