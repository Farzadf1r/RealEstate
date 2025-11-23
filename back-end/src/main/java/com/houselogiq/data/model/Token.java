package com.houselogiq.data.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.FieldType;
import org.springframework.data.mongodb.core.mapping.MongoId;

@Builder
@Document("tokens")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Token {

    @MongoId(FieldType.OBJECT_ID)
    private String id;
    private String lastModified;
    @Indexed
    private String userId;
    @Indexed(unique = true)
    private String token;
    private String status;
    @Indexed
    private String role;
//    private String creatorUserId;
//    private String generatorIp;
//    private String id;
//    ArrayList < Object > activeRoles = new ArrayList < Object > ();
//    private float version;
}
