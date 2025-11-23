package com.houselogiq.repository;

import com.houselogiq.data.model.AgentClient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AgentClientRepository extends MongoRepository<AgentClient, String> {

    @Query("{ 'clientId' : ?0, 'status' : ?1 }")
    Optional<AgentClient> findAlreadyAssigned(String clientId, String status);

    @Query("{ 'clientId' : ?0, 'agentId' : ?1, 'status' : ?2 }")
    Optional<AgentClient> findAlreadyAssignedToAgent(String clientId, String agentId, String status);

    @Query("{ 'agentId' : ?0, 'status' : ?1 }")
    Page<AgentClient> findClientsOfAgent(String agentId, String status, Pageable pageable);

    @Query(value = "{ 'agentId' : ?0, 'status' : ?1 }", count = true)
    Long countClientsOfAgent(String agentId, String status);

}
