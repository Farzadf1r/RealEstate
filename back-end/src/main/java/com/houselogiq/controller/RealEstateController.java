package com.houselogiq.controller;

import com.houselogiq.data.LogiqFile;
import com.houselogiq.data.LogiqReport;
import com.houselogiq.data.Point;
import com.houselogiq.data.ad.LogiqAd;
import com.houselogiq.data.ad.LogiqAds;
import com.houselogiq.data.model.Photo;
import com.houselogiq.data.model.User;
import com.houselogiq.data.token.LogiqClient;
import com.houselogiq.data.token.LogiqToken;
import com.houselogiq.service.*;
import com.houselogiq.util.LogiqContant;
import com.houselogiq.util.LogiqException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
public class RealEstateController {

    private static final Logger LOGGER = LoggerFactory.getLogger(RealEstateController.class);

    private final AdsService adsService;
    private final AgentService agentService;
    private final LoginManagementService loginManagementService;
    private final FavoriteService favoriteService;
    private final PhotoService photoService;

    public RealEstateController(AdsService adsService, AgentService agentService,
                                LoginManagementService loginManagementService,
                                FavoriteService favoriteService, PhotoService photoService) {
        this.adsService = adsService;
        this.agentService = agentService;
        this.loginManagementService = loginManagementService;
        this.favoriteService = favoriteService;
        this.photoService = photoService;
    }

    @GetMapping("ads")
    public LogiqAds searchAds(@RequestHeader Map<String, String> headers,
                              @RequestParam Map<String, String> allParams) {
        Optional<String> token = Optional.empty();
        if (headers.containsKey(LogiqContant.HEADER_USER_TOKEN)) {
            token = Optional.ofNullable(headers.get(LogiqContant.HEADER_USER_TOKEN));
        }
        Optional<User> loginUser = Optional.empty();
        if(token.isPresent() && token.get().length() > 0) {
            loginUser = Optional.of(loginManagementService.getUserOfOtp(token.get()));
        }
        return adsService.getListings(allParams,loginUser);
    }

    @GetMapping("ad/{mlsNumber}")
    public LogiqAd searchAdByMlsNumber(@RequestHeader Map<String, String> headers,
                                       @PathVariable("mlsNumber") String mlsNumber) {
        Optional<String> token = Optional.empty();
        if (headers.containsKey(LogiqContant.HEADER_USER_TOKEN)) {
            token = Optional.ofNullable(headers.get(LogiqContant.HEADER_USER_TOKEN));
        }
        Optional<User> loginUser = Optional.empty();
        if(token.isPresent() && token.get().length() > 0) {
            loginUser = Optional.of(loginManagementService.getUserOfOtp(token.get()));
        }
        return adsService.getListingsByMlsNumber(mlsNumber,loginUser);
    }

    @PostMapping("otp")
    public LogiqToken sendOtp(@RequestHeader(LogiqContant.HEADER_CUSTOMER_RECIPIENT) String recipient) {
        Optional.ofNullable(recipient).orElseThrow(() ->
                new LogiqException(String.format("header %s was not sent",
                        LogiqContant.HEADER_CUSTOMER_RECIPIENT)));
        return loginManagementService.sendToken(recipient);
    }

    @PostMapping("otp-verification")
    public ResponseEntity<LogiqClient.LogiqParent> verifyOtp(@RequestHeader Map<String, String> headers) {
        if (headers.keySet().stream().filter((key) ->
                key.contains(LogiqContant.HEADER_CUSTOMER_RECIPIENT)
                        || key.contains(LogiqContant.HEADER_OTP)).count() != 2) {
            throw new LogiqException(String.format("one of header %s , %s was not sent",
                    LogiqContant.HEADER_CUSTOMER_RECIPIENT,
                    LogiqContant.HEADER_OTP));
        }
        LogiqClient.LogiqParent client = loginManagementService.verifyToken(headers.get(LogiqContant.HEADER_CUSTOMER_RECIPIENT),
                headers.get(LogiqContant.HEADER_OTP));

        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                headers.get(LogiqContant.HEADER_OTP))
                .header(LogiqContant.HEADER_CUSTOMER_RECIPIENT,
                        headers.get(LogiqContant.HEADER_CUSTOMER_RECIPIENT)).body(client);
    }

    @GetMapping("agents")
    public ResponseEntity<LogiqReport<List<LogiqClient.LogiqSeller>>> getAgents(
            @RequestHeader(LogiqContant.HEADER_USER_TOKEN) String token,
            @RequestParam Map<String, String> allParams) {
        int page = 0;
        int pageSize = Integer.MAX_VALUE;
        if (allParams != null && allParams.size() > 0) {
            if (allParams.containsKey(LogiqContant.LOGIC_PAGE_INDEX)) {
                page = Integer.valueOf(allParams.get(LogiqContant.LOGIC_PAGE_INDEX));
            }
            if (allParams.containsKey(LogiqContant.LOGIC_PAGE_SIZE)) {
                pageSize = Integer.valueOf(allParams.get(LogiqContant.LOGIC_PAGE_SIZE));
            }
        }
        loginManagementService.validateToken(token);
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).body(agentService.getAgents(page, pageSize));
    }

    @GetMapping("agents/{agentId}")
    public ResponseEntity<LogiqClient.LogiqSeller> getAgentById(@RequestHeader(LogiqContant.HEADER_USER_TOKEN) String token,
                                                                @PathVariable("agentId") String agentId) {
        Optional.ofNullable(agentId).orElseThrow(() ->
                new LogiqException(String.format("%s was not sent",
                        LogiqContant.PATH_AGENT_ID)));
        loginManagementService.validateToken(token);
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).body(agentService.getAgent(agentId));
    }

    @GetMapping("customers/{userId}")
    public ResponseEntity<LogiqClient.LogiqCustomer> getCustomerById(@RequestHeader(LogiqContant.HEADER_USER_TOKEN) String token,
                                                                     @PathVariable(value = "userId") String userId) {
        loginManagementService.validateToken(token);
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).body(agentService.getCustomerById(userId));
    }

    @GetMapping("customers")
    public ResponseEntity<LogiqReport<List<LogiqClient.LogiqCustomer>>> getCustomers(
            @RequestHeader(LogiqContant.HEADER_USER_TOKEN) String token,
            @RequestParam Map<String, String> allParams) {
        int page = 0;
        int pageSize = Integer.MAX_VALUE;
        if (allParams != null && allParams.size() > 0) {
            if (allParams.containsKey(LogiqContant.LOGIC_PAGE_INDEX)) {
                page = Integer.valueOf(allParams.get(LogiqContant.LOGIC_PAGE_INDEX));
            }
            if (allParams.containsKey(LogiqContant.LOGIC_PAGE_SIZE)) {
                pageSize = Integer.valueOf(allParams.get(LogiqContant.LOGIC_PAGE_SIZE));
            }
        }
        loginManagementService.validateToken(token);
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).body(agentService.getCustomersOfAgent(token, page, pageSize));
    }

    @DeleteMapping("customers/{clientId}/agents")
    public ResponseEntity removeFromAgent(@RequestHeader(LogiqContant.HEADER_USER_TOKEN) String token,
                                          @PathVariable(value = "clientId") String clientId) {
        loginManagementService.validateToken(token);
        agentService.releaseCustomer(clientId);
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).build();
    }

    @PostMapping("customer-invitation")
    public ResponseEntity inviteCustomer(@RequestHeader Map<String, String> headers) {
        if (headers.keySet().stream().filter((key) ->
                key.contains(LogiqContant.HEADER_USER_TOKEN)
                        || key.contains(LogiqContant.HEADER_CUSTOMER_EMAIL)
                        || key.contains(LogiqContant.HEADER_CUSTOMER_MESSAGE)).count() != 3) {
            throw new LogiqException(String.format("one of header %s , %s , %s was not sent",
                    LogiqContant.HEADER_USER_TOKEN,
                    LogiqContant.HEADER_CUSTOMER_EMAIL,
                    LogiqContant.HEADER_CUSTOMER_MESSAGE));
        }
        String token = headers.get(LogiqContant.HEADER_USER_TOKEN);
        loginManagementService.validateToken(token);
        agentService.takeCustomer(token,
                headers.get(LogiqContant.HEADER_CUSTOMER_EMAIL),
                headers.get(LogiqContant.HEADER_CUSTOMER_MESSAGE));
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).build();
    }

    @PutMapping("favorites-sell-tag/{mlsNumber}")
    public void addFavoriteForSeller(@RequestHeader("user-token") String token,
                                     @PathVariable(value = "mlsNumber") String mlsNumber) {
        User userOfOtp = loginManagementService.getUserOfOtp(token);
        favoriteService.assignFavoriteToUser(userOfOtp, mlsNumber);
    }

    @DeleteMapping("favorites-sell-tag/{mlsNumber}")
    public void removeFavoriteFromSeller(@RequestHeader("user-token") String token,
                                         @PathVariable(value = "mlsNumber") String mlsNumber) {
        User userOfOtp = loginManagementService.getUserOfOtp(token);
        favoriteService.deleteFavoriteFromUser(userOfOtp, mlsNumber);
    }

    @PutMapping("favorites-buy-tag/{mlsNumber}")
    public void addFavoriteForClient(@RequestHeader("user-token") String token,
                                     @PathVariable(value = "mlsNumber") String mlsNumber) {
        User userOfOtp = loginManagementService.getUserOfOtp(token);
        favoriteService.assignFavoriteToUser(userOfOtp, mlsNumber);
    }

    @DeleteMapping("favorites-buy-tag/{mlsNumber}")
    public void removeFavoriteFromClient(@RequestHeader("user-token") String token,
                                         @PathVariable(value = "mlsNumber") String mlsNumber) {
        User userOfOtp = loginManagementService.getUserOfOtp(token);
        favoriteService.deleteFavoriteFromUser(userOfOtp, mlsNumber);
    }

    @PutMapping("user/profile")
    public ResponseEntity getUserProfile(@RequestHeader("user-token") String token,
                               @RequestParam Map<String, String> allParams) {
        if (allParams.keySet().stream().filter((key) ->
                key.contains(LogiqContant.PARAMETER_FIRST_NAME)
                        || key.contains(LogiqContant.PARAMETER_LAST_NAME)).count() != 2) {
            throw new LogiqException(String.format("one of parameter %s , %s was not sent",
                    LogiqContant.PARAMETER_FIRST_NAME,
                    LogiqContant.PARAMETER_LAST_NAME));
        }
        loginManagementService.validateToken(token);
        agentService.updateUser(token, allParams.get(LogiqContant.PARAMETER_FIRST_NAME),
                allParams.get(LogiqContant.PARAMETER_LAST_NAME));
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).build();
    }

    @PutMapping(value = "user/profilepic"/*,
            produces = MediaType.IMAGE_JPEG_VALUE*/
    )
    public ResponseEntity uploadUserProfilePic(@RequestHeader("user-token") String token,
                                               @RequestBody byte[] file) throws IOException {
        LOGGER.debug("file {}",file.length);
        User userOfOtp = loginManagementService.getUserOfOtp(token);
        Photo photoOfUser = photoService.assignPhotoToUser(userOfOtp, file);
//        Optional<Photo> photoOfUser = photoService.getPhotoOfUser(userOfOtp.getId());
        LOGGER.debug("fileId {}",photoOfUser.getId());
        LogiqFile logiqFile = LogiqFile.builder().file(photoOfUser.getImage().getData())
                .fileId(photoOfUser.getId()).build();
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).body(logiqFile);
    }

    @GetMapping(value = "user/profilepic",
            produces = MediaType.IMAGE_JPEG_VALUE
    )
    public ResponseEntity getUserProfilePic(@RequestHeader("user-token") String token) throws IOException {
        User userOfOtp = loginManagementService.getUserOfOtp(token);
//        Photo photoOfUser = photoService.assignPhotoToUser(userOfOtp, file);
        Optional<Photo> photoOfUser = photoService.getPhotoOfUser(userOfOtp.getId());
        LOGGER.debug("fileId {}",photoOfUser.get().getId());
        return ResponseEntity.ok().header(LogiqContant.HEADER_USER_TOKEN,
                token).body(photoOfUser.get().getImage().getData());
    }

    @GetMapping("adsgeo")
    public LogiqAds getAdsGeo(@RequestHeader Map<String, String> headers) {
        if (headers.keySet().stream().filter((key) ->
                key.contains(LogiqContant.HEADER_BOTTOM_LEFT_LONG)
                        || key.contains(LogiqContant.HEADER_BOTTOM_LEFT_LAT)
                        || key.contains(LogiqContant.HEADER_TOP_RIGHT_LONG)
                        || key.contains(LogiqContant.HEADER_TOP_RIGHT_LAT)).count() != 4) {
            throw new LogiqException(String.format("one of parameter %s , %s , %s , %s  was not sent",
                    LogiqContant.HEADER_BOTTOM_LEFT_LONG,
                    LogiqContant.HEADER_BOTTOM_LEFT_LAT,LogiqContant.HEADER_TOP_RIGHT_LONG,
                    LogiqContant.HEADER_TOP_RIGHT_LAT));
        }
        Optional<String> token = Optional.empty();
        if (headers.containsKey(LogiqContant.HEADER_USER_TOKEN)) {
            token = Optional.ofNullable(headers.get(LogiqContant.HEADER_USER_TOKEN));
        }
        Optional<User> loginUser = Optional.empty();
        if(token.isPresent() && token.get().length() > 0) {
            loginUser = Optional.of(loginManagementService.getUserOfOtp(token.get()));
        }
        List<Point> geos = new ArrayList<>();
        geos.add(new Point(headers.get(LogiqContant.HEADER_BOTTOM_LEFT_LONG),
                headers.get(LogiqContant.HEADER_BOTTOM_LEFT_LAT)));
        geos.add(new Point(headers.get(LogiqContant.HEADER_TOP_RIGHT_LONG),
                headers.get(LogiqContant.HEADER_TOP_RIGHT_LAT)));
        geos.add(new Point(headers.get(LogiqContant.HEADER_BOTTOM_LEFT_LONG),
                headers.get(LogiqContant.HEADER_TOP_RIGHT_LAT)));
        geos.add(new Point(headers.get(LogiqContant.HEADER_TOP_RIGHT_LONG),
                headers.get(LogiqContant.HEADER_BOTTOM_LEFT_LAT)));
        return adsService.getListingsBaseOnGeos(geos,loginUser);

    }

}
