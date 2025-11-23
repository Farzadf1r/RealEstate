package com.houselogiq.util;

import org.apache.commons.validator.routines.EmailValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.lang.NonNull;

public class LogiqValidator {

    private static final Logger LOGGER = LoggerFactory.getLogger(LogiqValidator.class);

    public LogiqValidator() {
        throw new IllegalStateException();
    }

    public static String validateEmail(@NonNull String recipient) {
        recipient = recipient.trim().toLowerCase();
        if (!EmailValidator.getInstance().isValid(recipient)) {
            LOGGER.warn("the email {} is invalid", recipient);
            throw new LogiqException("Email is invalid...");
        }
        return recipient;
    }

}
