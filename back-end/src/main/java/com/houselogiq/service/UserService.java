package com.houselogiq.service;

import com.houselogiq.data.model.AgentClient;
import com.houselogiq.data.model.RoleType;
import com.houselogiq.data.model.StatusType;
import com.houselogiq.data.model.User;
import com.houselogiq.repository.AgentClientRepository;
import com.houselogiq.repository.UserRepository;
import com.houselogiq.util.LogiqException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static com.houselogiq.util.LogiqContant.FORMATTER;

@Service
public class UserService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserService.class);

    private AgentClientRepository agentClientRepository;
    private UserRepository userRepository;

    public UserService(AgentClientRepository agentClientRepository, UserRepository userRepository) {
        this.agentClientRepository = agentClientRepository;
        this.userRepository = userRepository;
    }

    public User getUser(String recipient) {
        Optional<User> user = userRepository.findUserByEmail(recipient, StatusType.VALID.name());
        return user.orElseThrow(() -> new LogiqException(String.format("user with email %s not found",
                recipient)));
    }

    public User getUserById(String id) {
        Optional<User> user = userRepository.findById(id, StatusType.VALID.name());
        return user.orElseThrow(() -> new LogiqException(String.format("user with id %s not found", id)));
    }

    public User getUserByEmail(String recipient) {
        return userRepository.findUserByEmail(recipient, StatusType.VALID.name())
                .orElse(null);
    }

    public User getUserByEmailAndRole(String recipient, Set<String> roleTypes) {
        return userRepository.findUserByEmailAndRole(recipient,roleTypes, StatusType.VALID.name())
                .orElse(null);
    }

    public User createAgent(String recipient) {
        return createUser(recipient, Set.of(RoleType.AGENT.name()));
    }

    public User createClient(String recipient) {
        return createUser(recipient, Set.of(RoleType.CLIENT.name()));
    }

    private User createUser(String recipient, Set<String> roleTypes) {
        User user = getUserByEmailAndRole(recipient, roleTypes);
        if (user == null) {
            user = getUserByEmail(recipient);
            if( user == null) {
                user = User.builder()
                        .email(recipient).roles(roleTypes.stream().findFirst().get())
                        .lastModified(LocalDateTime.now().format(FORMATTER))
                        .status(StatusType.VALID.name()).build();
            }else{
//                user.getRoles().addAll(roleTypes);
                user.setRoles(roleTypes.stream().findFirst().get());
                user.setLastModified(LocalDateTime.now().format(FORMATTER));
            }
            user = userRepository.save(user);
        }
        return user;
    }

    public User updateUser(User user) {
        user.setLastModified(LocalDateTime.now().format(FORMATTER));
        return userRepository.save(user);
    }

    public List<User> getUserByRole(RoleType role, Integer page, Integer pageSize) {
        Pageable paging = PageRequest.of(page, pageSize);
        return userRepository.findUserByRole(Set.of(role.name()),
                StatusType.VALID.name(), paging).getContent();
    }

    public Long countUserByRole(RoleType role) {
        return userRepository.findUserByRoleCount(Set.of(role.name()),
                StatusType.VALID.name());
    }

    public Optional<AgentClient> getClientOfAgent(String clientId, String agentId) {
        return agentClientRepository.findAlreadyAssignedToAgent(clientId, agentId, StatusType.VALID.name());
    }

    public Optional<AgentClient> getClient(String clientId) {
        return agentClientRepository.findAlreadyAssigned(clientId, StatusType.VALID.name());
    }

    public AgentClient saveAgentClient(AgentClient agentClient) {
        agentClient.setLastModified(LocalDateTime.now().format(FORMATTER));
        return agentClientRepository.save(agentClient);
    }

    public List<AgentClient> getClientsOfAgent(String agentId, String status,
                                               Integer page, Integer pageSize) {
        Pageable paging = PageRequest.of(page, pageSize);
        return agentClientRepository.findClientsOfAgent(agentId, status, paging).getContent();
    }

    public Long countClientsOfAgent(String agentId) {
        return agentClientRepository.countClientsOfAgent(agentId, StatusType.VALID.name());
    }

    public Optional<User> getAgentOfClient(String clientId) {
        Optional<AgentClient> agentClient = getClient(clientId);
//                .orElse(null)/*ElseThrow( () -> new LogiqException(String.format("client %s has not any agent ",
//                        clientId)))*/;
        User user = null;
        if(agentClient.isPresent())
            user = getUserById(agentClient.get().getAgentId());
        return Optional.ofNullable(user);
    }

    public List<User> getUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.DESC, "lastModified"));
    }

    public void deleteUsers() {
        userRepository.deleteAll();
    }

    public void deleteUserByEmail(String email) {
        Optional<User> userByEmail = userRepository.findUserByEmail(email);
        if(userByEmail.isPresent()){
            userRepository.deleteById(userByEmail.get().getId());
        }
    }

    public List<AgentClient> getRelations() {
        return agentClientRepository.findAll();
    }

    public void deleteRelations() {
        agentClientRepository.deleteAll();
    }

    public void deleteRelationsByAgentEmail(String agentEmail) {
        User user = getUser(agentEmail);
        Optional<AgentClient> clientOfAgent = getClient(user.getId());
        if(clientOfAgent.isPresent()){
            clientOfAgent.stream().forEach( t -> {
                agentClientRepository.delete(t);
            });
        }
    }

    public void deleteRelationsByClientEmail(String clientEmail) {
        User user = getUser(clientEmail);
        Optional<AgentClient> agentOfClient = getClient(user.getId());
        if(agentOfClient.isPresent()) {
            agentClientRepository.delete(agentOfClient.get());
        }
    }

    public void assignClientToAgent(String clientEmail, String agentEmail) {
        User clientUser = getUser(clientEmail);
        User agentUser = getUser(agentEmail);
        Optional<AgentClient> clientOfAgent = getClientOfAgent(agentUser.getId(),agentUser.getId());
        clientOfAgent.ifPresentOrElse(t -> {LOGGER.debug("relation exit {}",t); },() -> {
            AgentClient agentClient = AgentClient.builder().agentId(agentUser.getId())
                            .clientId(clientUser.getId()).status(StatusType.VALID.name())
                            .build();
            agentClientRepository.save(agentClient);
        });

    }
}
