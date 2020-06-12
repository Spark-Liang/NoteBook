#### ARM Template

- CLI用法
  
  - 创建deployment

- 资源相关的重要概念

- 创建模板
  
  - 模板来源
  
  - 模板结构
  
  - 模板引用
  
  - 模板函数
  
  - 模板测试



##### CLI 用法

###### 创建 deployment

```bash
az deployment group create \
--resource-group <resource-group> --name <name> \
--template-file <local path of template file> \
--template-uri <the uri of the template file> \
--parameters < @{path} or JSON String or Key=Value pairs >
--rollback-on-error 

```

**对于parameters，az 命令是顺序处理每一个 parameters 对应的参数。所以后面的会把前面的参数覆盖。**



##### 创建模板

###### 模板来源

**在部署资源时获取，该创建资源当前配置下的模板文件。**



**官网各个资源的模板参考**

[https://docs.microsoft.com/en-us/azure/templates/](https://docs.microsoft.com/en-us/azure/templates/)



###### 模板结构

[https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax)

模板总体结构有：

- \$schema：定个模板的JSON结构

- contentVersion：可以是任意字符串，用于标识模板所使用的的版本

- apiProfile：可选，用于全局定义模板中所有资源所使用的的api版本。

- parameters：可选，定义该模板有哪些可以配置的参数

- variables：可选，用于定义全局可以用的变量

- functions：可选，用于定义用户自定义函数。**模板的用户自定义函数主要用于替换某些通用的逻辑。自定义函数所用到的元素都只能是内置函数**

- resources：定义所有需要的资源。

- outputs：定义执行完之后返回的值





###### 模板引用

[https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates)

模板引用主要有两种方式，一种是在当前文本中直接嵌套。另一种是通过uri 引用外部模板文件。

使用模板引用有以下优点：

- 外部模板能够得到内部模板的返回值。
  
  - 例子
    
    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
      },
      "variables": {
        "exampleVar": "from parent template"
      },
      "resources": [
        {
          ...
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "variables": {
                "exampleVar": "from nested template"
              },
              "resources": [
              ],
              "outputs": {
                "testVar": {
                  "type": "string",
                  "value": "[variables('exampleVar')]"
                }
              }
            }
          }
        }
      ],
      "outputs": {
        "messageFromLinkedTemplate": {
          "type": "string",
          "value": "[reference('nestedTemplate1').outputs.testVar.value]"
        }
      }
    }
    ```

- 
