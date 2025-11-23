package com.houselogiq.repository;

import com.houselogiq.data.model.Photo;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PhotoRepository extends MongoRepository<Photo, String> {

    @Query("{ 'userId' : ?0, 'status' : ?1 }")
    Optional<Photo> findAlreadyAssigned(String userId, String status);

}
