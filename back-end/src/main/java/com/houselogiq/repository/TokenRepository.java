package com.houselogiq.repository;

import com.houselogiq.data.model.Token;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TokenRepository extends MongoRepository<Token, String> {

//    @Query("{name:'?0'}")
//    Token findItemByName(String name);
//
    @Query(value="{userId:'?0'}")
    List<Token> findAllUserToken(String userId);

//    @Query(value="{token:'?0'}")
    Token findByTokenAndStatus(String token, String status);
//
//    public long count();

}
