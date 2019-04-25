# boot-shiro-redisson
Springboot based, with Shiro Redisson

采用github上封装好的[实现](https://github.com/streamone/shiro-redisson/wiki/%E4%B8%AD%E6%96%87)

### 之前尝试过使用spring boot shiro redis
- 现在这边尝试的redisson，主要的原因是redisson和jedis之间的区别

- 整个redisson和netty的协议进行了完全的整合，包括handler的介入，eventGroup的使用等，都使用了全套的netty体系

- 由于netty提供了promise功能，这里也大量使用了相应的异步模型来进行数据处理,异步发送，监听器监听返回消息并响应

-  redisson : java 5线程语义，Promise编程语义

- 相比jedis，其支持的特性并不是很高，但对于日常的使用还是没有问题的，完成了一个基本的redis网络实现，可以理解为redisson是一个完整的框架，而jedis即完成了语言层的适配

- redisson在使用来说，是隔绝底层实现，类似JPA一样的，面向领域设计，将信息转化为领域事件，开箱即用，代码规范

### 本示例中没有覆盖的点
```text
在 Shiro 中，org.apache.shiro.util.SimpleByteSource 没有继承 Serializable 接口。

当使用 JDK 序列化方式时，如果你通过这个构造函数 org.apache.shiro.authc.SimpleAuthenticationInfo.SimpleAuthenticationInfo(Object principal, Object hashedCredentials, ByteSource credentialsSalt, String realmName)并使用 SimpleByteSource 实例来构建SimpleAuthenticationInfo，序列化过程会因 java.io.NotSerializableException异常而失败。

为了解决这个问题，shiro-redisson 提供了 com.github.streamone.shiro.util.SerializableByteSource这个类。

new SimpleAuthenticationInfo(user.getAccount(),
    user.getPassword(),
    new SerializableByteSource(ByteSource.Util.bytes(Base64.decode(user.getSalt()))),
    this.getName());

```

### 对比 shiro-redisson 和 Shiro内置的 session 实现,[引自github原文](https://github.com/streamone/shiro-redisson/wiki/%E4%B8%AD%E6%96%87)
```text
Shiro 提供了内置的 session dao：org.apache.shiro.session.mgt.eis.EnterpriseCacheSessionDAO，它依赖 Shiro Cache 来实现 session 持久化。通常，EnterpriseCacheSessionDAO 和 org.apache.shiro.cache.ehcache.EhCacheManager 被结合在一起使用，以利用 EhCache 的高性能和磁盘持久化特性来管理 session。

对于单机环境，这是一个很好的解决方案，但是它不支持集群和分布式环境。面对这些环境，官方推荐使用 EhCache 结合 Terracotta来满足。而 shiro-redisson 是另一个可选的基于 redis 的方案。

其它的不同点：

shiro-redisson 提供了 com.github.streamone.shiro.session.RedissonSessionDao，它被设计成不依赖于 Shiro Cache，因为 Cache API 在性能和一致性两个方面不适合用于 Session。
EnterpriseCacheSessionDAO 会序列化并保存完整的 session 实例到缓存中， 尽管你只是更新其中的一个属性。这是效率低下的，并且在高并发下会造成脏数据。而 RedissonSessionDao 以属性为 session 序列化的最小单元。

org.apache.shiro.session.mgt.SimpleSession 是 Shiro 的默认 session 实现。其中使用 readObject/writeObject 方法对 JDK 序列化过程进行了个性化定制，这样做对其它序列化方案并不友好。shiro-redisson 提供了一个新的实现：com.github.streamone.shiro.session.RedissonSession，它不仅支持 JDK 序列化，还支持一些其它的序列化方案，比如 JSON、Smile、MsgPack、FST等。详见 https://github.com/redisson/redisson/wiki/2.-配置方法#codec编码

Shiro 内置的 session manager 使用计划任务来清理失效 session。而 shiro-redisson 使用 redis 的 “Expire” 命令来达到相同的效果。这个命令为 redis 中的 key 设置超时时间。 超时之后这个 key 会被自动删除。
```


### 可扩展部分
- 之前在spring boot shiro redis部分做了fastjson的自定义序列化，这边也可以同样使用，但暂未集成进来