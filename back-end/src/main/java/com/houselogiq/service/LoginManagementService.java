package com.houselogiq.service;

import com.houselogiq.data.model.Photo;
import com.houselogiq.data.model.RoleType;
import com.houselogiq.data.model.Token;
import com.houselogiq.data.model.User;
import com.houselogiq.data.token.LogiqClient;
import com.houselogiq.data.token.LogiqToken;
import com.houselogiq.util.LogiqException;
import com.houselogiq.util.LogiqValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Set;

@Service
public class LoginManagementService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LoginManagementService.class);

    private TokenService tokenService;
    private UserService userService;
    private MailService mailService;
    private PhotoService photoService;

    public LoginManagementService(TokenService tokenService, UserService userService,
                                  MailService mailService, PhotoService photoService) {
        this.tokenService = tokenService;
        this.userService = userService;
        this.mailService = mailService;
        this.photoService = photoService;
    }

    public LogiqToken sendToken(String email) {
        email = LogiqValidator.validateEmail(email);
        String otp = tokenService.generateOtp();
        User user = adjustTokenForUser(email, otp);
        mailService.sendOtpEmail(email, otp);
        LogiqToken token = LogiqToken.builder().token(otp).name(email).role(Set.of(user.getRoles())).build();
        return token;
    }

    public LogiqClient.LogiqParent verifyToken(String email, String otp) {
        email = LogiqValidator.validateEmail(email);
        User user = userService.getUser(email);
//        byte[] profilePictureFile
        Token token = tokenService.getToken(otp);
        if (!user.getRoles().contains(token.getRole())) {
            throw new LogiqException(String.format("user %s has not related to otp %s with role %s ",
                    email, otp, token.getRole()));
        }
        Optional<Photo> photoOfUser = photoService.getPhotoOfUser(user.getId());
        if (photoOfUser.isPresent()) {
            LOGGER.debug("user {} has photo {} with size {} and type {}"
                    , user.getId(), photoOfUser.isPresent(),
                    photoOfUser.get().getImage().length(), photoOfUser.get().getImage().length());
            user.setProfilePictureFile(photoOfUser.get().getId()/*new String(photoOfAgent.get().getImage().getData()*/);
        }
        LogiqClient.LogiqParent child = null;//new LogiqClient.LogiqAdmin();
        LogiqClient.LogiqParent container = null;
//        LogiqClient.LogiqCustomer logiqCustomer = null;//new LogiqClient.LogiqCustomer();
//        LogiqClient.LogiqSeller logiqSeller = null;// new LogiqClient.LogiqSeller();
        switch (token.getRole()) {
            case "AGENT":
                Long count = userService.countClientsOfAgent(user.getId());
                int representingCustomersCount = count != null ? count.intValue() : 0;
                int invitationsCount = representingCustomersCount;
                child = LogiqClient.LogiqSeller.builder()
                        .invitationsCount(invitationsCount).representingCustomersCount(representingCustomersCount)
                        .user(LogiqClient.LogiqUser.build(user)).build();
                container = LogiqClient.LogiqClientSeller.builder().seller(child).build();
                break;
            case "CLIENT":
                Optional<User> agent = userService.getAgentOfClient(user.getId());
                LogiqClient.LogiqSeller representativeSeller = null;
                if(agent.isPresent()) {
                    representativeSeller = LogiqClient.LogiqSeller.build(agent.get());
                    Optional<Photo> photoOfAgent = photoService.getPhotoOfUser(agent.get().getId());
                    if(photoOfAgent.isPresent()){
//                        LOGGER.debug("user {} has photo {} with size {} and type {}"
//                                , user.getId(), photoOfAgent.isPresent(),
//                                photoOfAgent.get().getImage().length(), photoOfAgent.get().getImage().length());
                        agent.get().setProfilePictureFile(photoOfAgent.get().getId()/*new String(photoOfAgent.get().getImage().getData())*/);
                    }
                }
                child = LogiqClient.LogiqCustomer.builder().representativeSeller(representativeSeller)
                        .user(LogiqClient.LogiqUser.build(user)).build();
                container = LogiqClient.LogiqClientCustomer.builder().customer(child).build();
                break;
            case "ADMIN":
                child = LogiqClient.LogiqAdmin.build(user);
                container = LogiqClient.LogiqClientAdmin.builder().admin(child).build();
                break;
        }
        return container;
    }

    public User getUserOfOtp(String agentOtp) {
        Token token = tokenService.getToken(agentOtp);
        return userService.getUserById(token.getUserId());
    }

    public User adjustTokenForUser(String recipient, String otp) {
        User user = userService.getUserByEmail(recipient);
        String role = "";
        if (user == null) {
            user = userService.createClient(recipient);
            role = RoleType.CLIENT.name();
        } else {
            role = user.getRoles();//.stream().findFirst().orElse(RoleType.ADMIN.name());
            tokenService.disablePreviousSession(user.getId());
        }
        tokenService.createToken(user.getId(), role, otp);
        return user;
    }

    public void validateToken(String token) {
        LOGGER.info("validating input token {}", token);
        tokenService.getToken(token);
    }
}
