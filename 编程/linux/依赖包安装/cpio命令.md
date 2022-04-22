#### cpio相关

解压到当前路径

```bash
cpio -idmv [target directory] < ../xxx.cpio
```

创建cpio包

```bash
find . | cpio -o -H newc > ../xxxxxxxxxxxxxxx.cpio
```
