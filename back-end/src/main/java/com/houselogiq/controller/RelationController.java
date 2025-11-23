package com.houselogiq.controller;

import com.houselogiq.data.model.AgentClient;
import com.houselogiq.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("relations")
@RestController
public class RelationController {

    private UserService userService;

    public RelationController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("")
    public List<AgentClient> getRelations() {
        return userService.getRelations();
    }

    @DeleteMapping("")
    public ResponseEntity deleteRelations() {
        userService.deleteRelations();
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @DeleteMapping("/{agentEmail}")
    public ResponseEntity deleteRelationsByAgentEmail(@PathVariable("agentEmail") String agentEmail) {
        userService.deleteRelationsByAgentEmail(agentEmail);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @DeleteMapping("/agent/{clientEmail}")
    public ResponseEntity deleteRelationByClientEmail(@PathVariable("clientEmail") String clientEmail) {
        userService.deleteRelationsByClientEmail(clientEmail);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @PostMapping("/{agentEmail}/{clientEmail}")
    public ResponseEntity assignClientToAgent(@PathVariable("agentEmail") String agentEmail,
                                              @PathVariable("clientEmail") String clientEmail) {
        userService.assignClientToAgent(clientEmail, agentEmail);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
