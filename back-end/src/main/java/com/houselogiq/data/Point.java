package com.houselogiq.data;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Point {

    private String longitude;
    private String latitude;

    public String point(){
        return "[" + longitude + "," + latitude + "]";
    }

}
