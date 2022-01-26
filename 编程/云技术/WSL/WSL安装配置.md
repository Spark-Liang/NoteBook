### WSL安装配置

- windows启动wsl

##### windows启动wsl

使用powershell依次运行命令

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform 

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux 
```



##### 卸载

```powershell
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform 
```
