package com.houselogiq.controller;

import com.houselogiq.data.model.User;
import com.houselogiq.data.token.LogiqToken;
import com.houselogiq.service.LoginManagementService;
import com.houselogiq.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("users")
@RestController
public class UserController {

    private LoginManagementService loginManagementService;
    private UserService userService;

    public UserController(LoginManagementService loginManagementService, UserService userService) {
        this.loginManagementService = loginManagementService;
        this.userService = userService;
    }

    @PostMapping("{email}/otp")
    public LogiqToken sendOtpMessage(@PathVariable("email") String email) {
        return loginManagementService.sendToken(email);
    }

    @PostMapping("/agent/{email}")
    public User createAgent(@PathVariable("email") String email) {
        return userService.createAgent(email);
    }

    @PostMapping("/client/{email}")
    public User createClient(@PathVariable("email") String email) {
        return userService.createClient(email);
    }

    @GetMapping("")
    public List<User> getUsers() {
        return userService.getUsers();
    }

    @GetMapping("/email")
    public User getUserByMail(@PathVariable("email") String email) {
        return userService.getUserByEmail(email);
    }

    @DeleteMapping("")
    public ResponseEntity deleteUsers() {
        userService.deleteUsers();
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @DeleteMapping("/{email}")
    public ResponseEntity deleteUserByEmail(@PathVariable("email") String email) {
        userService.deleteUserByEmail(email);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @PutMapping("")
    public User updateUser(@RequestBody User user) {
        userService.getUserById(user.getId());
        return userService.updateUser(user);
    }


}
