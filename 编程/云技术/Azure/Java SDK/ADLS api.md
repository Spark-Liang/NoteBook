#### ADLS api

- 身份验证
  
  - 获取client 实例
  
  - 获取AccessToken







##### 身份验证

###### 获取AccessToken



```java
ApplicationTokenCredentials credentials = new ApplicationTokenCredentials(
    //client id
                "XXX"
                , TENANT_ID
    // client secret
                , "XXX"
                , AzureEnvironment.AZURE
        );


        System.out.println(
                credentials.getToken(
                        "https://<account name>.core.windows.net"
                        //"https://login.microsoftonline.com/"
                )
        );


```
