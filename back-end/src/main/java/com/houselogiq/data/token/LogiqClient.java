package com.houselogiq.data.token;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.houselogiq.data.model.User;
import com.houselogiq.util.LogiqContant;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.*;


//@Data
//@Builder
//@NoArgsConstructor
//@AllArgsConstructor
//@JsonIgnoreProperties(value = { "Seller", "Admin" })
public class LogiqClient {

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LogiqClientSeller implements LogiqParent{

        @JsonProperty(value = "Seller", defaultValue = "")
        private LogiqParent seller;

    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LogiqClientCustomer implements LogiqParent {

        @JsonProperty(value = "Customer", defaultValue = "")
        private LogiqParent customer;

    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LogiqClientAdmin implements LogiqParent {

        @JsonProperty(value = "Admin", defaultValue = "")
        private LogiqParent admin;

    }

    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Data
    public static class LogiqSeller implements LogiqParent{

        private LogiqUser user;
//        private LogiqTag favoriteProductsToSellTag;
//        private LogiqTag allowedToSellProductsTag;
        private Integer invitationsCount;
        private Integer representingCustomersCount;

        public static LogiqSeller build(User user) {
            return builder().user(LogiqUser.build(user))
//                    .favoriteProductsToSellTag(LogiqTag.build(user))
//                    .allowedToSellProductsTag(LogiqTag.build(user))
                    .invitationsCount(1).representingCustomersCount(1)
                    .build();
        }

    }

    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Data
//    @JsonIgnoreProperties(value = {"representativeSeller"})
    public static class LogiqCustomer implements LogiqParent{

        private LogiqUser user;
//        private LogiqTag favoriteProductsTag;
        private LogiqSeller representativeSeller;
//        private LogiqSeller representativeAgent;

//        private String creatorUserId;
//        private String id;
//        private String lastModified;
//        private Integer version;

        public static LogiqCustomer build(User agent, User user) {
            return builder().user(LogiqUser.build(user))
//                    .favoriteProductsTag(LogiqTag.build(user))
//                            .countOfStuffTagged(1).description("").title("")
//                            .build())
                    .representativeSeller(LogiqSeller.build(agent))
//                    .creatorUserId("").id(user.getId()).lastModified(LocalDateTime.now().format(FORMATTER))
//                    .version(10)
                    .build();
        }
        public static LogiqCustomer build(User user) {
            return builder().user(LogiqUser.build(user))
//                    .favoriteProductsTag(LogiqTag.build(user))
//                            .countOfStuffTagged(1).description("").title("")
//                            .build())
//                    .representativeSeller(LogiqSeller.build(agent))
//                    .creatorUserId("").id(user.getId()).lastModified(LocalDateTime.now().format(FORMATTER))
//                    .version(10)
                    .build();
        }
    }

    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Data
    public static class LogiqAdmin implements LogiqParent{

        private LogiqUser user;

        public static LogiqAdmin build(User user) {
            return builder().user(LogiqUser.build(user))
                    .build();
        }

    }

    public interface LogiqParent {

    }

    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Data
    public static class LogiqUser {

//        private String userid;
        private String userName;
        private String firstName;
        @JsonProperty(value = "LastName", defaultValue = "")
        private String lastName;
//        private String mobile;
        private String email;
        private Set<String> rolesTitles;
        private Map<String, Object> extraProperties;
//        final company = user.extraProperties["agentCompany"];
//        final website = user.extraProperties["agentWebsite"];
//        private String address;
        private String profilePictureFile;

        private String id;
//        private String _id;
//        private String creatorUserId;
//        private String lastModified;
//        private String password;
//        private Boolean isVerified;
//        private Integer version;
//        private Set<String> rolesIds;

//        private Boolean isAgent;
//        private Boolean isCustomer;
//        private Boolean isAdmin;
//        private Boolean isAnonymous;


//        private String company;
//        private String website;

        public static LogiqUser build(User user) {
            Set<String> role = new HashSet<>();
//            final boolean[] roles = {false, false, false, false};
//            user.getRoles().stream().forEach(t -> {
//                switch (t) {
//                    case "AGENT":
//                        role.add("Agent");
////                        roles[0] = true;
//                        break;
//                    case "CLIENT":
//                        role.add("Customer");
////                        roles[1] = true;
//                        break;
//                    case "ADMIN":
//                        role.add("Admin");
////                        roles[2] = true;
//                        break;
//                    case "ANONYMOUS":
//                        role.add("Anonymous");
////                        roles[3] = true;
//                        break;
//
//                }
//            });

            switch (user.getRoles()) {
                    case "AGENT":
                        role.add("Seller");
//                        roles[0] = true;
                        break;
                    case "CLIENT":
                        role.add("Customer");
//                        roles[1] = true;
                        break;
                    case "ADMIN":
                        role.add("Admin");
//                        roles[2] = true;
                        break;
                    case "ANONYMOUS":
                        role.add("Anonymous");
//                        roles[3] = true;
                        break;

                }
            return builder().firstName(Optional.ofNullable(user.getFirstName()).orElse(LogiqContant.DEFAULT_FIRST_NAME))
                    .lastName(Optional.ofNullable(user.getLastName()).orElse(LogiqContant.DEFAULT_LAST_NAME))
                    .email(Optional.ofNullable(user.getEmail()).orElse(LogiqContant.DEFAULT_EMAIL))
                    .rolesTitles(role).extraProperties(user.getExtraProperties()).profilePictureFile(user.getProfilePictureFile())
                    .extraProperties(new HashMap<>()).id(user.getId())
                    /*.version(1).rolesIds(Set.of(UUID.randomUUID().toString())).userName("")
                    .lastModified(LocalDateTime.now().format(FORMATTER)).isVerified(true)
                    .password("")._id(user.getId()).id(UUID.randomUUID().toString()).mobile("")
                    .creatorUserId("").isAdmin(roles[2]).isAnonymous(roles[3]).isAgent(roles[0]).isCustomer(roles[1])*/
                    .build();
        }

//    private List<String> rolesIds;
    }

//    @Builder
//    @NoArgsConstructor
//    @AllArgsConstructor
//    @Data
//    public static class LogiqTag {
//
//        private String title;
//        private String description;
////        private Integer countOfStuffTagged;
//
//        private String creatorUserId;
//        private String id;
//        private String lastModified;
//        private String _id;
//        private Integer version;
//        private Integer countOfTaggedStuff;
//
//        public static LogiqTag build(User user) {
//            return builder().title("MyFavoriteProductsToBuy")._id(user.getId())
//                    .version(203).id(UUID.randomUUID().toString()).countOfTaggedStuff(1)
//                    .description("").lastModified(LocalDateTime.now().format(FORMATTER))
//                    .creatorUserId("")
//                    .build();
//        }
//    }
}
