package com.houselogiq.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.CommonsRequestLoggingFilter;

@Configuration
public class CustomRequestLoggingFiler {

    @Bean
    public CommonsRequestLoggingFilter requestLoggingFilter() {
        CommonsRequestLoggingFilter loggingFilter = new CommonsRequestLoggingFilter();
        loggingFilter.setIncludeClientInfo(true);
        loggingFilter.setIncludeQueryString(true);
        loggingFilter.setIncludePayload(true);
        loggingFilter.setIncludeHeaders(true);
        loggingFilter.setMaxPayloadLength(6400000);
        return loggingFilter;
    }
//    @Autowired
//    @Bean
//    public FilterRegistrationBean requestResponseFilter() {
//
//        final FilterRegistrationBean filterRegBean = new FilterRegistrationBean();
//        TeeFilter filter = new TeeFilter();
//        filterRegBean.setFilter(filter);
//        filterRegBean.setUrlPatterns("/rest/path");
//        filterRegBean.setName("Request Response Filter");
//        filterRegBean.setAsyncSupported(Boolean.TRUE);
//        return filterRegBean;
//    }
}
