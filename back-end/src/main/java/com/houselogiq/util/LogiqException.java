package com.houselogiq.util;

public class LogiqException extends RuntimeException{

    public LogiqException() {
        super("something bad happened in LOGIQ...contact the administrator");
    }

    public LogiqException(String message) {
        super(message);
    }
}
