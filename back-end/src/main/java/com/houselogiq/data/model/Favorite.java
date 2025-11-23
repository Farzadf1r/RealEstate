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
@Document("favorites")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Favorite {

    @MongoId(FieldType.OBJECT_ID)
    private String id;
    private String lastModified;
    @Indexed
    private String userId;
    @Indexed
    private String mlsNumber;
    @Indexed
    private String status;

}
