package com.houselogiq.data.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.Binary;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.FieldType;
import org.springframework.data.mongodb.core.mapping.MongoId;

@Builder
@Document("photos")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Photo {

    @MongoId(FieldType.OBJECT_ID)
    private String id;
    private String lastModified;
    @Indexed
    private String userId;
    private Binary image;
    @Indexed
    private String status;

}
