rebel是eclipse下用于实现热加载的插件。

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<application xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.zeroturnaround.com" xsi:schemaLocation="http://www.zeroturnaround.com http://www.zeroturnaround.com/alderaan/rebel-2_0.xsd">  
    <classpath>  
        <dir name="${myproject.root}/bin">  
        </dir>  
        <dir name="${myproject.root}/web/WebContent/WEB-INF/classes">  
        </dir>  
    </classpath>  
    <web>  
        <link target="/">  
            <dir name="${myproject.root}/web/WebContent">  
            </dir>  
        </link>  
    </web>  
</application>  
```

**接着选中对应项目，右键点进properties，设置generate rebel.xml用于生成对应的xml文件**
