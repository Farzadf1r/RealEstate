package com.houselogiq.repository;

import com.houselogiq.data.model.Favorite;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends MongoRepository<Favorite, String> {

    @Query("{ 'userId' : ?0, 'mlsNumber' : ?1, 'status' : ?2 }")
    Optional<Favorite> findAlreadyAssigned(String userId, String mlsNumber, String status);

    @Query("{ 'userId' : ?0, 'status' : ?1 }")
    Page<Favorite> findFavoritesByUserId(String userId, String status, Pageable pageable);

    @Query(value = "{ 'userId' : ?0, 'status' : ?1 }", count = true)
    Long countFavoritesByUserId(String userId, String status);

    @Query("{ 'userId' : ?0, 'status' : ?1 }")
    Optional<List<Favorite>> findAlreadyAssigned(String userId, String status);
}
