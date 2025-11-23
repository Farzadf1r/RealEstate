package com.houselogiq.service;

import com.houselogiq.data.model.StatusType;
import com.houselogiq.data.model.Token;
import com.houselogiq.repository.TokenRepository;
import com.houselogiq.util.LogiqException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

import static com.houselogiq.util.LogiqContant.FORMATTER;

@Service
public class TokenService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TokenService.class);

    private TokenRepository tokenRepository;

    public TokenService(TokenRepository tokenRepository) {
        this.tokenRepository = tokenRepository;
    }

    public Token getToken(String otp) {
        Token token = tokenRepository.findByTokenAndStatus(otp, StatusType.VALID.name());
        if (token == null) {
            throw new LogiqException(String.format("token %s not found", otp));
        }
        return token;
    }

    public void disablePreviousSession(String userId) {
        List<Token> list = tokenRepository.findAllUserToken(userId);
        list.stream().forEach(t -> {
            t.setStatus(StatusType.INVALID.name());
            tokenRepository.save(t);
        });
    }

    public Token createToken(String userId, String role, String otp) {
        Token token = Token.builder().token(otp)
                .userId(userId).lastModified(LocalDateTime.now().format(FORMATTER))
                .status(StatusType.VALID.name()).role(role)
                .build();
        return tokenRepository.save(token);
    }

    public String generateOtp() {
        int next = new Random(System.currentTimeMillis()).nextInt(999999) + 100000;
        String otp = String.valueOf(next);
        LOGGER.debug("generated Otp {}", otp);
        return otp;
    }

    public List<Token> getTokens() {
        return tokenRepository.findAll();
    }

    public void deleteTokens() {
        tokenRepository.deleteAll();
    }
}
