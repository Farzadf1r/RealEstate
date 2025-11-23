package com.houselogiq.repository;

import com.houselogiq.data.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.Set;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

    @Query("{email:'?0' , status: '?1'}")
    Optional<User> findUserByEmail(String email, String status);

    @Query("{email:'?0'}")
    Optional<User> findUserByEmail(String email);

    @Query("{email:'?0' , roles: { $in : ?1 } , status: '?1' }")
    Optional<User> findUserByEmailAndRole(String recipient, Set<String> roles, String status);

    @Query("{id:'?0' , status: '?1' }")
    Optional<User> findById(String id, String status);

    @Query("{roles: { $in : ?0 }  , status: '?1' }")
    Page<User> findUserByRole(Set<String> roles, String status, Pageable pageable);

    @Query(value = "{roles: { $in : ?0 }  , status: '?1'}", count = true)
    Long findUserByRoleCount(Set<String> roles, String status);
}
