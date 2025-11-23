package com.houselogiq.controller;

import com.houselogiq.data.model.Favorite;
import com.houselogiq.data.model.User;
import com.houselogiq.service.FavoriteService;
import com.houselogiq.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("favorites")
@RestController
public class FavoriteController {

    private FavoriteService favoriteService;
    private UserService userService;

    public FavoriteController(FavoriteService favoriteService, UserService userService) {
        this.favoriteService = favoriteService;
        this.userService = userService;
    }

    @GetMapping("")
    public List<Favorite> getFavorites() {
        return favoriteService.getFavorites();
    }

    @DeleteMapping("")
    public ResponseEntity deleteFavorites() {
        favoriteService.deleteFavorites();
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @DeleteMapping("/{email}/{mlsNumber}")
    public ResponseEntity deleteFavoriteByUserId(@PathVariable("mlsNumber") String mlsNumber,
                                                 @PathVariable("email") String email) {
        User userByEmail = userService.getUserByEmail(email);
        favoriteService.deleteFavoriteFromUser(userByEmail, mlsNumber);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @PostMapping("/{email}/{mlsNumber}")
    public ResponseEntity assignFavoriteToUserId(@PathVariable("mlsNumber") String mlsNumber,
                                                 @PathVariable("email") String email) {
        User userByEmail = userService.getUserByEmail(email);
        favoriteService.assignFavoriteToUser(userByEmail, mlsNumber);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
