package com.houselogiq.service;

import com.houselogiq.data.model.Photo;
import com.houselogiq.data.model.StatusType;
import com.houselogiq.data.model.User;
import com.houselogiq.repository.PhotoRepository;
import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static com.houselogiq.util.LogiqContant.FORMATTER;

@Service
public class PhotoService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PhotoService.class);

    private final PhotoRepository photoRepository;

    public PhotoService(PhotoRepository photoRepository) {
        this.photoRepository = photoRepository;
    }

    public Photo updatePhoto(Photo photo) {
        photo.setLastModified(LocalDateTime.now().format(FORMATTER));
        return photoRepository.save(photo);
    }

    public List<Photo> getPhotos() {
        return photoRepository.findAll();
    }

    public void deletePhotos() {
        photoRepository.deleteAll();
    }


    public void deletePhotoFromUser(User user) {
        Optional<Photo> photoOfUser = getPhotoOfUser(user.getId());
        photoOfUser.ifPresentOrElse((t) -> {
            t.setStatus(StatusType.INVALID.name());
            updatePhoto(t);
        }, () -> LOGGER.debug("photo dose not exit for user {} ", user.getId()));
    }

    public Optional<Photo> getPhotoOfUser(String userId) {
        return photoRepository.findAlreadyAssigned(userId, StatusType.VALID.name());
    }

    public Photo assignPhotoToUser(User user, byte[] images) {
        Optional<Photo> photoOfUser = getPhotoOfUser(user.getId());
        photoOfUser.ifPresent(t -> {
            invalidatePhotos(photoOfUser.get());
            LOGGER.debug("photo exit {}", t);
        });
        Photo photo = Photo.builder().image(new Binary(BsonBinarySubType.BINARY, images))
                .userId(user.getId()).status(StatusType.VALID.name())
                .lastModified(LocalDateTime.now().format(FORMATTER))
                .build();
        return photoRepository.save(photo);
    }

    private void invalidatePhotos(Photo photo) {
        photo.setLastModified(LocalDateTime.now().format(FORMATTER));
        photo.setStatus(StatusType.INVALID.name());
        photoRepository.save(photo);
    }

}
