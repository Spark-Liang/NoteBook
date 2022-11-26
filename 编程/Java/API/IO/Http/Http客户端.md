### Http客户端

#### HttpClient

##### 依赖配置

```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpmime</artifactId>
</dependency>
```

##### 文件上传

示例代码

```java
public void testUpload() throws Exception{
    CloseableHttpClient client = HttpClients.createDefault();
    HttpPost post = new HttpPost();
    post.setURI(new URIBuilder("http://127.0.0.1:8080/fileUpload/upload1")
            .build());
    post.setEntity(MultipartEntityBuilder.create()
            .setContentType(ContentType.MULTIPART_FORM_DATA)
            .addPart("file",new InputStreamBody(new ByteArrayInputStream("test".getBytes(StandardCharsets.UTF_8)),"tmp.txt"))
            .build());
    HttpResponse response = client.execute(post);
    System.out.println(new BufferedReader(new InputStreamReader(response.getEntity().getContent())).lines().collect(Collectors.joining("")));;
}
```

注意点：

- 其中每个part代表一个参数。part的名称“file”代表的是参数名。
