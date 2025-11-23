package com.houselogiq.service;

import com.houselogiq.data.LogiqReport;
import com.houselogiq.data.model.AgentClient;
import com.houselogiq.data.model.RoleType;
import com.houselogiq.data.model.StatusType;
import com.houselogiq.data.model.User;
import com.houselogiq.data.token.LogiqClient;
import com.houselogiq.util.LogiqException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.houselogiq.util.LogiqContant.FORMATTER;

@Service
public class AgentService {

    private static final Logger LOGGER = LoggerFactory.getLogger(AgentService.class);

    private UserService userService;
    private LoginManagementService loginManagementService;
    private MailService mailService;

    public AgentService(UserService userService, LoginManagementService loginManagementService,
                        MailService mailService) {
        this.userService = userService;
        this.loginManagementService = loginManagementService;
        this.mailService = mailService;
    }

    public void takeCustomer(String agentOtp, String email, String message) {
        User agent = loginManagementService.getUserOfOtp(agentOtp);
        if (!isAgent(agent)) {
            throw new LogiqException(String.format("user %s must be agent ",
                    agent.getEmail()));
        }
        User client = userService.getUser(email);
//        if(agent.getId() == client.getId()){
//            throw new LogiqException(String.format("agent %s and client %s are the same",
//                    agent.getEmail(),email));
//        }
        Optional<AgentClient> agentClient = userService.getClientOfAgent(client.getId(),agent.getId());
        if (!agentClient.isPresent()) {
            agentClient = userService.getClient(client.getId());
            if (agentClient.isPresent()) {
                throw new LogiqException(String.format("client %s has already assigned ",
                        email));
            }
            AgentClient agntClnt = AgentClient.builder().agentId(agent.getId()).clientId(client.getId())
                    .lastModified(LocalDateTime.now().format(FORMATTER))
                    .status(StatusType.VALID.name()).build();
            userService.saveAgentClient(agntClnt);
            mailService.sendInvitationEmail(email, message);
        }
    }

    private boolean isAgent(User agent) {
        boolean flag = true;
        if (!agent.getRoles().contains(RoleType.AGENT.name())) {
            flag = false;
        }
        return flag;
    }

    public void releaseCustomer(String clientId) {
        Optional<AgentClient> agentClient = userService.getClient(clientId);
        agentClient.ifPresent(t -> {
            t.setStatus(StatusType.INVALID.name());
            userService.saveAgentClient(t);
        });
    }

    public LogiqReport<List<LogiqClient.LogiqSeller>> getAgents(Integer page, Integer pageSize) {
        List<LogiqClient.LogiqSeller> result = new ArrayList<>();
        Long count = userService.countUserByRole(RoleType.AGENT);
        Long pageCount = 0L;
        if (count > 0) {
            pageCount = count / pageSize;
            List<User> users = userService.getUserByRole(RoleType.AGENT, page, pageSize);
            users.stream().forEach(t -> {
                result.add(LogiqClient.LogiqSeller.build(t));
            });
        }
        return LogiqReport.<List<LogiqClient.LogiqSeller>>builder().result(result)
                .pageCount(pageCount.intValue()).totalEntriesCount(count.intValue())
                .thisPageEntriesCount(pageSize).pageIndex(page).pageSize(pageSize).build();
    }

    public LogiqClient.LogiqSeller getAgent(String agentId) {
        User user = userService.getUserById(agentId);
        return LogiqClient.LogiqSeller.build(user);
    }

    public LogiqClient.LogiqCustomer getCustomerById(String userId) {
        User user = userService.getUserById(userId);
        return LogiqClient.LogiqCustomer.build(user);
    }

    public LogiqReport<List<LogiqClient.LogiqCustomer>> getCustomersOfAgent(String token, Integer page, Integer pageSize) {
        List<LogiqClient.LogiqCustomer> customers = new ArrayList<>();
        User agent = loginManagementService.getUserOfOtp(token);
        if (!isAgent(agent)) {
            throw new LogiqException(String.format("user %s must be agent ",
                    agent.getEmail()));
        }
        Long count = userService.countClientsOfAgent(agent.getId());
        Long pageCount = 0L;
        if (count > 0) {
            pageCount = count / pageSize;
            List<AgentClient> agentClients = userService.getClientsOfAgent(agent.getId(),
                    StatusType.VALID.name(), page, pageSize);
            if (Optional.ofNullable(agentClients).isPresent()) {
                LOGGER.debug("total client(s) of agent {}", agentClients.size());
                for (AgentClient ac : agentClients) {
                    customers.add(LogiqClient.LogiqCustomer.build(agent,
                            userService.getUserById(ac.getClientId())));
                }
            }
        }
        return LogiqReport.<List<LogiqClient.LogiqCustomer>>builder().result(customers)
                .pageCount(pageCount.intValue()).totalEntriesCount(count.intValue())
                .thisPageEntriesCount(pageSize).pageIndex(page).pageSize(pageSize).build();
    }

    public void updateUser(String token, String firstName, String lastName) {
        User user = loginManagementService.getUserOfOtp(token);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        userService.updateUser(user);
    }
}
