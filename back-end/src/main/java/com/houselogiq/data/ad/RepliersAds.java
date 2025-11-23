package com.houselogiq.data.ad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class RepliersAds {

    private Long page;
    private Long numPages;
    private Long pageSize;
    private Long count;
    private Statistics statistics;
    private List<RepliersAd> listings = new ArrayList();

    @Data
    public class Statistics {
        private ListPrice listPrice;

    }

    @Data
    public static class ListPrice {
        private Long min;
        private Long max;
    }
}