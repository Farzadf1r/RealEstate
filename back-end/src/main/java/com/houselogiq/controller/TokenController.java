package com.houselogiq.controller;

import com.houselogiq.data.model.Token;
import com.houselogiq.service.TokenService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequestMapping("tokens")
@RestController
public class TokenController {

    private TokenService tokenService;

    public TokenController(TokenService tokenService) {
        this.tokenService = tokenService;
    }

    @GetMapping("")
    public List<Token> getRelations() {
        return tokenService.getTokens();
    }

    @DeleteMapping("")
    public ResponseEntity deleteTokens() {
        tokenService.deleteTokens();
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

}
