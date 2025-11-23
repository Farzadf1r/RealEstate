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
@Document("agent_clients")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class AgentClient {

    @MongoId(FieldType.OBJECT_ID)
    private String id;
    private String lastModified;
    @Indexed
    private String agentId;
    @Indexed
    private String clientId;
    @Indexed
    private String status;

}
