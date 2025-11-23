package com.houselogiq.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLException;

@RestControllerAdvice
public class LogiqExceptionAdvice {

    private static final Logger LOGGER = LoggerFactory.getLogger(LogiqExceptionAdvice.class);

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler({RuntimeException.class, SQLException.class, Exception.class, LogiqException.class})
    public String handleRuntimeException(Exception e){
        LOGGER.error("{}",e);
        return e.getLocalizedMessage() + " , please contact the administrator...";
    }

}
