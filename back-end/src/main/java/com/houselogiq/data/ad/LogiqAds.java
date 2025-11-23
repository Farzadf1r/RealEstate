package com.houselogiq.data.ad;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class LogiqAds {
    private List<LogiqAd> result = new ArrayList<>();
    private Long pageCount;
    private Long pageIndex;
    private Long pageSize;
    private Long thisPageEntriesCount;
    private Long totalEntriesCount;
}
