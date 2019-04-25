package com.shiro.config;

import at.pollux.thymeleaf.shiro.dialect.ShiroDialect;
import com.github.streamone.shiro.cache.RedissonShiroCacheManager;
import com.github.streamone.shiro.session.RedissonSessionDao;
import com.github.streamone.shiro.session.RedissonWebSessionManager;
import com.shiro.credential.RetryLimitHashedCredentialsMatcher;
import com.shiro.filter.KickoutSessionControlFilter;
import com.shiro.repository.TUserRepository;
import com.shiro.security.SelfRealm;
import com.shiro.security.ShiroSessionListener;
import com.shiro.serializer.FastJsonRedisSerializer;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.authc.credential.CredentialsMatcher;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.authc.pam.AllSuccessfulStrategy;
import org.apache.shiro.authc.pam.ModularRealmAuthenticator;
import org.apache.shiro.cache.CacheManager;
import org.apache.shiro.cache.ehcache.EhCacheManager;
import org.apache.shiro.session.SessionListener;
import org.apache.shiro.session.mgt.ExecutorServiceSessionValidationScheduler;
import org.apache.shiro.session.mgt.SessionManager;
import org.apache.shiro.session.mgt.SimpleSessionFactory;
import org.apache.shiro.session.mgt.eis.JavaUuidSessionIdGenerator;
import org.apache.shiro.session.mgt.eis.MemorySessionDAO;
import org.apache.shiro.session.mgt.eis.SessionDAO;
import org.apache.shiro.spring.LifecycleBeanPostProcessor;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;

import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.filter.authz.SslFilter;
import org.apache.shiro.web.mgt.CookieRememberMeManager;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.apache.shiro.web.servlet.SimpleCookie;
import org.apache.shiro.web.session.mgt.DefaultWebSessionManager;
import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.codec.JsonJacksonCodec;
import org.redisson.config.Config;
import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.web.server.Ssl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.core.io.ClassPathResource;

import javax.servlet.Filter;
import java.io.IOException;
import java.util.*;

/**
 * Desciption
 *
 * @author Claire.Chen
 * @create_time 2019 -04 - 08 16:30
 */
@Configuration
@Slf4j
public class ShiroConfig {


    @Bean(name = "lifecycleBeanPostProcessor")
    public LifecycleBeanPostProcessor lifecycleBeanPostProcessor() {
        LifecycleBeanPostProcessor lifecycleBeanPostProcessor = new LifecycleBeanPostProcessor();
        return lifecycleBeanPostProcessor;
    }

    /**
     * 一个自定义的Realm进行身份认证
     *
     * @return
     */
    @Bean(name = "selfRealm")
    @DependsOn("lifecycleBeanPostProcessor")
    public SelfRealm selfRealm() {
   /*     SelfRealm selfRealm = new SelfRealm();
        selfRealm.setCredentialsMatcher();
        selfRealm.setCachingEnabled();  //默认为true
        selfRealm.setAuthorizationCachingEnabled(); //默认为true
        selfRealm.setAuthenticationCacheName();  //默认getClass().getName() + DEFAULT_AUTHORIZATION_CACHE_SUFFIX
        selfRealm.setAuthorizationCache();  //Cache<Object, AuthorizationInfo> authorizationCache
        selfRealm.setAuthorizationCacheName();//name + DEFAULT_AUTHORIZATION_CACHE_SUFFIX*/
        return new SelfRealm();
    }

    /*
    会话ID生成器
     */
    public JavaUuidSessionIdGenerator generator(){
        return  new JavaUuidSessionIdGenerator();
    }

    /**
     * 认证的入口，securityManager，并且把自定义的认证赋给它,安全管理器
     *
     * @return
     */
    @Bean(name = "securityManager")
    @DependsOn("credentialsMatcher")
    public org.apache.shiro.mgt.SecurityManager securityManager() throws IOException {
        DefaultWebSecurityManager manager = new DefaultWebSecurityManager();
        manager.setRealm(selfRealm());
        manager.setRememberMeManager(rememberMeManager());
        manager.setCacheManager(redissonShiroCacheManager());
        //manager.setCacheManager(ehCacheManager());
        manager.setSessionManager(sessionManager());
        return manager;
    }

    @Bean(name = "credentialsMatcher")
    public CredentialsMatcher credentialsMatcher() throws IOException {
        RetryLimitHashedCredentialsMatcher credentialsMatcher = new RetryLimitHashedCredentialsMatcher(redissonShiroCacheManager());
        credentialsMatcher.setHashAlgorithmName("MD5");
        credentialsMatcher.setHashIterations(2);
        credentialsMatcher.setRetryMax(10);
        //true加密用的hex编码，false用的base64编码
        credentialsMatcher.setStoredCredentialsHexEncoded(false);
        return  credentialsMatcher;
    }
    /**
     * 过滤器，表示接口的拦截和跳转
     *
     * @param securityManager
     * @return
     */
    @Bean(name = "shiroFilter")
    public ShiroFilterFactoryBean shirFilter(org.apache.shiro.mgt.SecurityManager securityManager) {
        ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();
        shiroFilterFactoryBean.setSecurityManager(securityManager);

        shiroFilterFactoryBean.setLoginUrl("/login");
        shiroFilterFactoryBean.setSuccessUrl("/index");
        shiroFilterFactoryBean.setUnauthorizedUrl("/403");

        LinkedHashMap<String, String> filterChainDefinitionMap = new LinkedHashMap<>();

        filterChainDefinitionMap.put("/css/**", "anon");
        filterChainDefinitionMap.put("/js/**", "anon");
        filterChainDefinitionMap.put("/fonts/**", "anon");
        filterChainDefinitionMap.put("/img/**", "anon");
        filterChainDefinitionMap.put("/druid/**", "anon");
        filterChainDefinitionMap.put("/logout", "logout");
        filterChainDefinitionMap.put("/", "anon");
        //filterChainDefinitionMap.put("/**", "authc");
        //user指的是用户认证通过或者配置了Remember Me记住用户登录状态后可访问,而不是每一次都需要认证
        filterChainDefinitionMap.put("/**", "user");


        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);

        return shiroFilterFactoryBean;
    }

    /**
     * cookie对象
     *
     * @return
     */
    public SimpleCookie rememberMeCookie() {
        SimpleCookie cookie = new SimpleCookie("rememberMe");
        //单位为秒
        cookie.setMaxAge(60);
        return cookie;
    }

    public CookieRememberMeManager rememberMeManager() {
        CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        cookieRememberMeManager.setCookie(rememberMeCookie());
        //cookie加密密钥
        //这个key是为了给带缓存的cookie进行加密，避免安全问题
        //这个key可以自行生成
        cookieRememberMeManager.setCipherKey(Base64.getDecoder().decode("4AvVhmFLUs0KTA3Kprsdag=="));
        return cookieRememberMeManager;
    }


    @Bean
    @DependsOn({"lifecycleBeanPostProcessor"})
    public DefaultAdvisorAutoProxyCreator advisorAutoProxyCreator() {
        DefaultAdvisorAutoProxyCreator advisorAutoProxyCreator = new DefaultAdvisorAutoProxyCreator();
        advisorAutoProxyCreator.setProxyTargetClass(true);
        return advisorAutoProxyCreator;
    }


    /**
     * spring mvc 相关的配置
     * @param securityManager
     * @return
     */
    @Bean
    public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(org.apache.shiro.mgt.SecurityManager securityManager) {
        AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor = new AuthorizationAttributeSourceAdvisor();
        authorizationAttributeSourceAdvisor.setSecurityManager(securityManager);
        return authorizationAttributeSourceAdvisor;
    }

    @Bean
    public RedissonClient redissonClient() throws IOException {
        ClassPathResource classPathResource = new ClassPathResource("redisson-config.yaml");
        Config config = Config.fromYAML(classPathResource.getInputStream());
        return Redisson.create(config);
    }

    @Bean
    @DependsOn("redissonClient")
    public RedissonShiroCacheManager redissonShiroCacheManager() throws IOException {
        RedissonShiroCacheManager cacheManager = new RedissonShiroCacheManager();
        cacheManager.setRedisson(redissonClient());
        cacheManager.setCodec(new JsonJacksonCodec());
        cacheManager.setConfigLocation("classpath:cache-config.yaml");
        cacheManager.init();
        return cacheManager;
    }

    @Bean
    public EhCacheManager ehCacheManager() {
        EhCacheManager ehCacheManager = new EhCacheManager();
        ehCacheManager.setCacheManagerConfigFile("classpath:config/shiro-ehcache.xml");
        return ehCacheManager;
    }

    @Bean
    public ShiroDialect shiroDialect() {
        return new ShiroDialect();
    }

  @Bean
  public RedissonSessionDao redisSessionDAO() throws IOException {
      RedissonSessionDao redissonSessionDao = new RedissonSessionDao();
      redissonSessionDao.setRedisson(redissonClient());
      redissonSessionDao.setCodec(new JsonJacksonCodec());
      return redissonSessionDao;
  }

    /**
     * 会话验证调度器
     * @return
     */
    public ExecutorServiceSessionValidationScheduler scheduler(){
        ExecutorServiceSessionValidationScheduler scheduler = new ExecutorServiceSessionValidationScheduler();
        scheduler.setInterval(1800000);
        scheduler.setThreadNamePrefix("scheduler-shiro-%d");
        return  scheduler;
    }

    /**
     * 会话管理器
     * @return
     */
    @Bean
    public SessionManager sessionManager() throws IOException {
        RedissonWebSessionManager webSessionManager = new RedissonWebSessionManager();
        webSessionManager.setSessionDAO(redisSessionDAO());
        webSessionManager.setGlobalSessionTimeout(180000);
        return webSessionManager;
    }


}
