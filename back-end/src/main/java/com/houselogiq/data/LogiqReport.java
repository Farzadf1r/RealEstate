package com.houselogiq.data;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LogiqReport<T> {

    private Integer pageIndex;
    private Integer pageSize;
    private Integer pageCount;
    private Integer thisPageEntriesCount;
    private Integer totalEntriesCount;
    private T result;

}
