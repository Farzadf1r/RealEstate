package com.houselogiq.data.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.FieldType;
import org.springframework.data.mongodb.core.mapping.MongoId;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@Builder
@Document("users")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class User {

    @MongoId(FieldType.OBJECT_ID)
    private String id;
    @Indexed
    private String firstName;
    @Indexed
    private String password;
    @Indexed
    private String lastName;
    @Indexed
    private String email;
    @Indexed
    private String roles;// = new HashSet<>();
    private String lastModified;
    private String status;
    private Map<String, Object> extraProperties = new HashMap<>();
    private String profilePictureFile;

//    private String userName;
//    private String creatorUserId;
//    private boolean isVerified;
//    private String mobile;
//    ArrayList < Object > extraProperties = new ArrayList < Object > ();
//    private float version;
//    private String id;
}
