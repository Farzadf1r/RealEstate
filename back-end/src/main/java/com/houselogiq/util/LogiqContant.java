package com.houselogiq.util;

import java.time.format.DateTimeFormatter;

public final class LogiqContant {

    public static final String LOGIC_PAGE_INDEX = "pageIndex";
    public static final String LOGIC_PAGE_SIZE = "pageSize";
    public static final String LOGIC_START_PRICE = "priceStartingFrom";
    public static final String LOGIC_END_PRICE = "priceUpTo";
    public static final String LOGIC_AD_CLASS = "adClass";
    public static final String LOGIC_AD_TYPE = "adType";
    public static final String LOGIC_STATUS = "status";
    public static final String LOGIC_ID = "id";
    public static final String LOGIC_PARKING_COUNT = "parkingCount";
    public static final String LOGIC_BEDROOM_COUNT = "bedroomsCount";
    public static final String LOGIC_BATHROOM_COUNT = "bathRoomsCount";
    public static final String LOGIC_SQFT_MAX = "propertySizeInSquareFeetAtMost";
    public static final String LOGIC_SQFT_MIN = "propertySizeInSquareFeetAtLeast";
    public static final String LOGIC_WORD = "word";
    //    public static final String DEFAUL_LOGIC_PAGE_INDEX      = "1";
//    public static final String DEFAUL_LOGIC_PAGE_SIZE       = "100";
    public static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    public static final String HEADER_USER_TOKEN = "user-token";
    public static final String HEADER_CUSTOMER_MESSAGE = "message";
    public static final String HEADER_CUSTOMER_EMAIL = "email";
    public static final String HEADER_CUSTOMER_RECIPIENT = "recipient";
    public static final String HEADER_OTP = "otp";
    public static final String PATH_AGENT_ID = "agentId";
    public static final CharSequence PARAMETER_FIRST_NAME = "first";
    public static final CharSequence PARAMETER_LAST_NAME = "last";
    public static final String DEFAULT_FIRST_NAME = "first_name";
    public static final String DEFAULT_LAST_NAME = "last_name";
    public static final String DEFAULT_EMAIL = "example@example.com";
    public static final String LOGIC_FAVORITE = "onlyFavoriteOnes";
    public static final String HEADER_BOTTOM_LEFT_LONG = "bl-lon";
    public static final String HEADER_BOTTOM_LEFT_LAT = "bl-lat";
    public static final String HEADER_TOP_RIGHT_LONG = "tr-lon";
    public static final String HEADER_TOP_RIGHT_LAT = "tr-lat";
    public static final String LOGIC_MAP_SEARCH = "onlyMaps";

    private LogiqContant() {
        throw new IllegalStateException();
    }

    public static class RepliersConstant {

        public static final String API_KEY = "REPLIERS-API-KEY";

        public enum Status {
            AVAILABLE("A"),
            UNAVAILABLE("U");

            private String name;

            Status(String value) {
                this.name = value;
            }

            public String getName() {
                return name;
            }
        }

        public enum SortBy {
            CREATED_ON_DESC("createdOnDesc"),
            UPDATED_ON_DESC("updatedOnDesc"),
            REATED_ON_ASC("reatedOnAsc"),
            DISTANCE_ASC("distanceAsc"),
            DISTANCE_DESC("distanceDesc"),
            UPDATED_ON_ASC("updatedOnAsc"),
            SOLD_DATE_ASC("soldDateAsc"),
            SOLD_DATE_DESC("soldDateDesc"),
            SOLD_PRICE_ASC("soldPriceAsc"),
            SOLD_PRICE_DESC("soldPriceDesc"),
            SQFT_ASC("sqftAsc"),
            SQFT_DESC("sqftDesc"),
            LIST_PRICE_ASC("listPriceAsc"),
            LIST_PRICE_DESC("listPriceDesc"),
            BEDS_ASC("bedsAsc"),
            BEDS_DESC("bedsDesc"),
            BATHS_DESC("bathsDesc"),
            BATHS_ASC("bathsAsc"),
            YEAR_BUILT_DESC("yearBuiltDesc"),
            YEAR_BUILT_ASC("yearBuiltAsc"),
            RANDOM("random");
            private String name;

            SortBy(String value) {
                this.name = value;
            }

            public String getName() {
                return name;
            }
        }

//        public static final String LOGIC_PAGE_INDEX = "pageIndex";
//        public static final String LOGIC_PAGE_SIZE = "pageSize";
//        public static final String DEFAUL_LOGIC_PAGE_INDEX = "1";
//        public static final String DEFAUL_LOGIC_PAGE_SIZE = "100";

        private RepliersConstant() {
            throw new IllegalStateException();
        }

    }
}
