#### samba安装

同时安装服务端和客户端

```bash
yum -y install samba samba-client 
```

[经过测试能够成功运行的 samba 对应的CentOS安装包可以从以下路径，找到对应版本的CentOS获取。](https://mail2gduteducn-my.sharepoint.com/personal/3114007149_mail2_gdut_edu_cn/_layouts/15/onedrive.aspx?FolderCTID=0x0120006E3F43EFA5917F4B94902C9173A2542C&id=%2Fpersonal%2F3114007149%5Fmail2%5Fgdut%5Fedu%5Fcn%2FDocuments%2Fshare%2FCentOS%20pkgs)

##### samba配置

samba的主配置文件在 /etc/samba/smb.conf 。该文件主要分为两个部分，一个是 [global] 标签下的全局配置，另外一部分是其他 [\<some resource\>] 标签的配置，这些标签中每个标签都对应着一个可访问的资源。

###### [global] 配置

配置模板：

```bash
[global]
    workgroup = SAMBA

    server string = Samba Server Version %v
    netbios name = Samba-Server

    log file = /var/log/samba/%m.log
    max log size = 10240
    security = user
    passdb backend = tdbsam
```

常用配置：

- workgroup = WORKGROUP  
  
  说明：设定 Samba Server 所要加入的工作组或者域。

- server string = Samba Server Version %v  
  
  说明：设定 Samba Server 的注释，可以是任何字符串，也可以不填。宏%v表示显示Samba的版本号。

- netbios name = smbserver  
  
  说明：设置Samba Server的NetBIOS名称。如果不填，则默认会使用该服务器的DNS名称的第一部分。netbios name和workgroup名字不要设置成一样了。

- interfaces = lo eth0 192.168.12.2/24 192.168.13.2/24  
  
  说明：设置Samba Server监听哪些网卡，可以写网卡名，也可以写该网卡的IP地址。

- hosts allow =  192.168.1.0/24 192.168.10.1  
  
  说明：表示允许连接到Samba Server的客户端，多个参数以空格隔开。可以用一个IP表示，也可以用一个网段表示。含义于 hosts deny 相反

- security = user
  
  - share： 不需要验证
  
  - user：使用 samba server管理的用户名密码验证。对应的用户名密码与 passdb backend 配置有关
  
  - server通过 windows NT 对应的server 进行验证
  
  - domain ：通过主域控制器完成验证

- passdb backend
  
  说明：passdb backend就是用户后台的意思。目前有三种后台：smbpasswd、tdbsam和ldapsam。sam应该是security account manager（安全账户管理）的简写。
  
  1. *smbpasswd*：该方式是使用smb自己的工具smbpasswd来给系统用户（真实  
     
     用户或者虚拟用户）设置一个Samba密码，客户端就用这个密码来访问Samba的资源。smbpasswd文件默认在/etc/samba目录下，不过有时候要手工建立该文件。
  
  2. *tdbsam*：该方式则是使用一个数据库文件来建立用户数据库。数据库文件叫passdb.tdb，默认在/etc/samba目录下。passdb.tdb用户数据库可以使用smbpasswd –a来建立Samba用户，<font color='red'>不过要建立的Samba用户必须先是系统用户。我们也可以使用pdbedit命令来建立Samba账户</font>。pdbedit命令的参数很多，我们列出几个主要的。
     
     > - pdbedit –a username：新建Samba账户。
     > - pdbedit –x username：删除Samba账户。
     > - pdbedit –L：列出Samba用户列表，读取passdb.tdb数据库文件。
     > - pdbedit –Lv：列出Samba用户列表的详细信息。
     > - pdbedit –c “[D]” –u username：暂停该Samba用户的账号。
     > - pdbedit –c “[]” –u username：恢复该Samba用户的账号。
  
  3. *ldapsam*：该方式则是基于LDAP的账户管理方式来验证用户。首先要建立LDAP服务，然后设置“passdb backend = ldapsam:ldap://LDAP Server”

- encrypt passwords = yes/no
  
  说明：是否将认证密码加密。因为现在windows操作系统都是使用加密密码，所以一般要开启此项。不过配置文件默认已开启。

[更多有关全局参数配置请看该链接](https://www.linuxidc.com/Linux/2017-11/148354.htm)或者 [该链接](ref/samba/CentOS 7下Samba服务安装与配置详解.html)

###### 其他共享资源配置

配置模板：

```bash
[shared]
    # 共享文件目录描述
    comment = Shared Directories  
    # 共享文件目录
    path = /storage/shared/%U
    # 是否允许guest访问
    public = no  
    # 指定管理用户
    admin users = admin 
    # 可访问的用户组、用户,多个用户或者组中间用逗号隔开
    valid users = @admin,@SmbUsers 
    # 是否浏览权限
    browseable = yes 
    # 是否可写权限
    writable = yes 
    # 文件默认权限设置
    create mask = 0775
    directory mask = 0775
    force directory mode = 0775
    force create mode = 0775
```

- comment = 任意字符串  
  
  说明：comment是对该共享的描述，可以是任意字符串。

- path = 共享目录路径  
  
  说明：path用来指定共享目录的路径。可以用%u、%m这样的宏来代替路径里的unix用户和客户机的Netbios名，用宏表示主要用于[homes]共享域。例如：如果我们不打算用home段做为客户的共享，而是在/home/share/下为每个Linux用户以他的用户名建个目录，作为他的共享目录，这样path就可以写成：path = /home/share/%u; 。用户在连接到这共享时具体的路径会被他的用户名代替，要注意这个用户名路径一定要存在，否则，客户机在访问时会找不到网络路径。同样，如果我们不是以用户来划分目录，而是以客户机来划分目录，为网络上每台可以访问samba的机器都各自建个以它的netbios名的路径，作为不同机器的共享资源，就可以这样写：path = /home/share/%m 。

- browseable = yes/no  
  
  说明：browseable用来指定该共享是否可以浏览。

- writable = yes/no  
  
  说明：writable用来指定该共享路径是否可写。

- available = yes/no  
  
  说明：available用来指定该共享资源是否可用。

- admin users = 该共享的管理者  
  
  说明：admin users用来指定该共享的管理员（对该共享具有完全控制权限）。在samba 3.0中，如果用户验证方式设置成“security=share”时，此项无效。  
  
  例如：admin users =bobyuan，jane（多个用户中间用逗号隔开）。

- valid users = 允许访问该共享的用户  
  
  说明：valid users用来指定允许访问该共享资源的用户。  
  
  例如：valid users = bobyuan，@bob，@tech（多个用户或者组中间用逗号隔开，<font color='red'>如果要加入一个组就用“@+组名”表示。</font>）

- invalid users = 禁止访问该共享的用户  
  
  说明：invalid users用来指定不允许访问该共享资源的用户。  
  
  例如：invalid users = root，@bob（多个用户或者组中间用逗号隔开。）

- write list = 允许写入该共享的用户  
  
  说明：write list用来指定可以在该共享下写入文件的用户。  
  
  例如：write list = bobyuan，@bob

- public = yes/no  
  
  说明：public用来指定该共享是否允许guest账户访问。

- guest ok = yes/no  
  
  说明：意义同“public”。

- create mask = 0777
  
  表示该目录下创建文件的对应权限，会把dos文件的权限映射成对应的unix权限，在映射后所得的权限，会与这个参数所定义的值进行与操作。然后再和下面的force create mode进行或操作，这样就得到最终linux下的文件权限。

- force create mode – 见上面的描述。相当于此参数所设置的权限位一定会出现在文件属性中。

- directory mask = 0777
  
  表示该目录下对应的目录的对应权限

- force directory mode – 见上面的描述。相当于此参数中所设置的权限位一定会出现在目录的属性中。

<font color='red'>新建文件权限 = dos 文件权限 & create mask | force create mode</font><br>
<font color='red'>新建文件夹权限 = dos 文件夹权限 & directory mask | force directory mode</font>

###### smb.conf中的内置变量

- %m：代表 Client 端的 NetBIOS 主機名稱喔！
- %M：代表 Client 端的 Internet 主機名稱喔！就是 HOSTNAME。
- %L：代表 SAMBA 主機的 NetBIOS 主機名稱。
- %H：代表使用者的家目錄。
- %U：代表目前登入的使用者的使用者名稱
- %g：代表登入的使用者的群組名稱。
- %h：代表目前這部 SAMBA 主機的 HOSTNAME 喔！注意是 hostname 不是 NetBIOS name 喔！
- %I：代表 Client 的 IP 咯。
- %T：代表目前的日期與時間

###### 错误收集

- Error  NT_STATUS_IO_TIMEOUT：
  - 在配置正确，samba所在server能够 ping 通并且 telnet 也能连接成功。则此时错误出现有可能是因为某个资源对应的目录没有被创建。
  
  - 在配置正确，samba所在server能够 ping 通并且 telnet 也能连接成功，对应的文件夹也存在。并且错误提示为 "protocol negotiation failed: NT_STATUS_IO_TIMEOUT"。则有可能是因为使用了外网的DNS。
- NT_STATUS_LOGON_FAILURE
  - 原因是没有对应的smb用户或者对应的smb 密码不正确
- NT_STATUS_INVALID_NETWORK_RESPONSE

#### smbclient 使用

- 列出指定samba server 对应的资源：
  
  smbclient -L \<server ip or dns name\> -U \<user name\>

- 使用 smbclient 连接远程server：
  
  smbclient //\<server ip or dns name\>/\<resource name\> -U \<user name\>

#### 参考链接：

- [鸟哥的Linux私房菜](http://linux.vbird.org/linux_server/0370samba.php#)

- 
