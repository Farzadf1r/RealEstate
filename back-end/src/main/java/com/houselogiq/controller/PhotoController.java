package com.houselogiq.controller;

import com.houselogiq.data.model.Photo;
import com.houselogiq.data.model.User;
import com.houselogiq.service.PhotoService;
import com.houselogiq.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RequestMapping("photos")
@RestController
public class PhotoController {

    private PhotoService photoService;
    private UserService userService;

    public PhotoController(PhotoService photoService, UserService userService) {
        this.photoService = photoService;
        this.userService = userService;
    }

    @GetMapping("")
    public List<Photo> getPhotos() {
        return photoService.getPhotos();
    }

    @GetMapping(value = "/{email}",
            produces = MediaType.IMAGE_JPEG_VALUE
    )
    public byte[] getPhotoByEmail(@PathVariable("email") String email) {
        User user = userService.getUserByEmail(email);
        Optional<Photo> photoOfUser = photoService.getPhotoOfUser(user.getId());
        if(photoOfUser.isPresent()){
            return photoOfUser.get().getImage().getData();
        }
        return null;
    }

    @DeleteMapping("")
    public ResponseEntity deletePhotos() {
        photoService.deletePhotos();
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @DeleteMapping("/{email}")
    public ResponseEntity deletePhotoByUserId(@PathVariable("email") String email) {
        User userByEmail = userService.getUserByEmail(email);
        photoService.deletePhotoFromUser(userByEmail);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @PostMapping("/{email}")
    public ResponseEntity assignPhotoToUserId(@PathVariable("email") String email,
                                              @RequestBody byte[] file) {
        User userByEmail = userService.getUserByEmail(email);
        photoService.assignPhotoToUser(userByEmail, file);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
