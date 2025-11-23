package com.houselogiq.service;

import com.houselogiq.data.model.Favorite;
import com.houselogiq.data.model.StatusType;
import com.houselogiq.data.model.User;
import com.houselogiq.repository.FavoriteRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static com.houselogiq.util.LogiqContant.FORMATTER;

@Service
public class FavoriteService {

    private static final Logger LOGGER = LoggerFactory.getLogger(FavoriteService.class);

    private FavoriteRepository favoriteRepository;

    public FavoriteService(FavoriteRepository favoriteRepository) {
        this.favoriteRepository = favoriteRepository;
    }

    public Favorite updateFavorite(Favorite favorite) {
        favorite.setLastModified(LocalDateTime.now().format(FORMATTER));
        return favoriteRepository.save(favorite);
    }

    public Long countFavoritesOfUser(String userId) {
        return favoriteRepository.countFavoritesByUserId(userId, StatusType.VALID.name());
    }

    public List<Favorite> getFavorites() {
        return favoriteRepository.findAll();
    }

    public void deleteFavorites() {
        favoriteRepository.deleteAll();
    }


    public void deleteFavoriteFromUser(User user, String mlsNumber) {
        Optional<Favorite> favOfUser = getFavoriteOfUser(user.getId(), mlsNumber);
        favOfUser.ifPresentOrElse((t) -> {
            t.setStatus(StatusType.INVALID.name());
            updateFavorite(t);
        }, () -> {
            LOGGER.debug("favorite {} dose not exit for user {} ", mlsNumber, user.getId());
        });
    }

    private Optional<Favorite> getFavoriteOfUser(String userId, String mlsNumber) {
        return favoriteRepository.findAlreadyAssigned(userId, mlsNumber, StatusType.VALID.name());
    }

    public void assignFavoriteToUser(User user, String mlsNumber) {
        Optional<Favorite> favOfUser = getFavoriteOfUser(user.getId(), mlsNumber);
        favOfUser.ifPresentOrElse(t -> {
            LOGGER.debug("relation exit {}", t);
        }, () -> {
            Favorite favorite = Favorite.builder().mlsNumber(mlsNumber)
                    .userId(user.getId()).status(StatusType.VALID.name())
                    .lastModified(LocalDateTime.now().format(FORMATTER))
                    .build();
            favoriteRepository.save(favorite);
        });
    }

    public Optional<List<Favorite>> getFavoritesOfUserId(String userId) {
        return favoriteRepository.findAlreadyAssigned(userId, StatusType.VALID.name());
    }
}
