package com.houselogiq.service;

import com.houselogiq.data.Point;
import com.houselogiq.data.ad.*;
import com.houselogiq.data.model.Favorite;
import com.houselogiq.data.model.User;
import com.houselogiq.util.LogiqContant;
import com.houselogiq.util.LogiqConvertor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(AdsService.class);

    @Value("${repliers.baseUrl}")
    private String baseUrl;

    @Value("${repliers.listings}")
    private String listings;

    @Value("${repliers.accessToken}")
    private String accessToken;

    @Value("${repliers.defaultResultsPerPage}")
    private Integer defaultResultsPerPage;

    @Value("${repliers.defaultPageNum}")
    private Integer defaultPageNum;

    private FavoriteService favoriteService;

    public AdsService(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    public LogiqAds getListings(Map<String, String> allParams, Optional<User> loginUser){
        LOGGER.debug("all parameter is : {}",allParams);

        HttpHeaders headers = getRepliersHeader();
        var url = baseUrl + listings;
        UriComponentsBuilder urlTemplate = UriComponentsBuilder.fromHttpUrl(url);
        Map<String, Object> params = new HashMap<>();
        Set<String> loginFavorits = new HashSet<>();
        boolean isfavorite = false;
        boolean fromMap = false;
        if(allParams != null && allParams.size() > 0){

            isfavorite = allParams.containsKey(LogiqContant.LOGIC_FAVORITE) ?
                    Boolean.valueOf(allParams.get(LogiqContant.LOGIC_FAVORITE)) : false;
            fromMap = allParams.containsKey(LogiqContant.LOGIC_MAP_SEARCH) ?
                    Boolean.valueOf(allParams.get(LogiqContant.LOGIC_MAP_SEARCH)) : false;
            int i = 0;
            if (allParams.containsKey(LogiqContant.LOGIC_ID)) {
                String tmp = allParams.get(LogiqContant.LOGIC_ID);
                if (tmp != null && tmp.length() > 0 && Long.valueOf(tmp) > 0) {
                    urlTemplate = urlTemplate.queryParam("mlsNumber", "{mlsNumber" + i + "}");
                    params.put("mlsNumber" + i, tmp);
                    i++;
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_PAGE_INDEX)){
                urlTemplate = urlTemplate.queryParam("pageNum", "{pageNum}");
                String tmp = allParams.get(LogiqContant.LOGIC_PAGE_INDEX);
                if(tmp == null || tmp.length() == 0 || tmp.equals("0"))
                    tmp = defaultPageNum.toString();//HosueLogiqContant.DEFAUL_LOGIC_PAGE_INDEX;
                params.put("pageNum", tmp);
            }
            if(allParams.containsKey(LogiqContant.LOGIC_PAGE_SIZE)){
                urlTemplate = urlTemplate.queryParam("resultsPerPage", "{resultsPerPage}");
                String tmp = allParams.get(LogiqContant.LOGIC_PAGE_SIZE);
                if(tmp == null || tmp.length() == 0 || tmp.equals("0")
                        || Long.valueOf(tmp) > 10000)
                    tmp = defaultResultsPerPage.toString(); //HosueLogiqContant.DEFAUL_LOGIC_PAGE_SIZE;
                params.put("resultsPerPage", tmp);
            }
            if(allParams.containsKey(LogiqContant.LOGIC_START_PRICE)){
                String tmp = allParams.get(LogiqContant.LOGIC_START_PRICE);
                if(tmp != null && tmp.length() > 0 && Long.valueOf(tmp) > 0 ) {
                    urlTemplate = urlTemplate.queryParam("minPrice", "{minPrice}");
                    params.put("minPrice", tmp);
                }
            }
//            if(allParams.containsKey(LogiqContant.LOGIC_END_PRICE)){
//                String tmp = allParams.get(LogiqContant.LOGIC_END_PRICE);
//                if(tmp != null && tmp.length() > 0 && Long.valueOf(tmp) > 0 ) {
//                    urlTemplate = urlTemplate.queryParam("maxPrice", "{maxPrice}");
//                    params.put("maxPrice", tmp);
//                }
//            }
            if(allParams.containsKey(LogiqContant.LOGIC_AD_CLASS)){
                String tmp = allParams.get(LogiqContant.LOGIC_AD_CLASS);
                if(tmp != null && tmp.length() > 0 && !tmp.equalsIgnoreCase("ANY") ) {
                    urlTemplate = urlTemplate.queryParam("class", "{class}");
                    params.put("class", LogiqConvertor.convertFromClass(tmp));
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_AD_TYPE)){
                String tmp = allParams.get(LogiqContant.LOGIC_AD_TYPE);
                if(tmp != null && tmp.length() > 0 && !tmp.equalsIgnoreCase("ANY") ) {
                    urlTemplate = urlTemplate.queryParam("type", "{type}");
                    params.put("type", LogiqConvertor.convertFromType(tmp));
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_STATUS)){
                String tmp = allParams.get(LogiqContant.LOGIC_STATUS);
                if(tmp != null && tmp.length() > 0 && !tmp.equalsIgnoreCase("ANY") ) {
                    urlTemplate = urlTemplate.queryParam("lastStatus", "{lastStatus}");
                    params.put("lastStatus", LogiqConvertor.convertFromStatus(tmp));
                }else{
//                    List<String> sts = LogiqConvertor.getAnonymousStatus();
//                    for (String s : sts) {
//                        urlTemplate = urlTemplate.queryParam("lastStatus", "{lastStatus}");
//                        params.put("lastStatus", s );
//                    }
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_ID)){
                String tmp = allParams.get(LogiqContant.LOGIC_ID);
                if(tmp != null && tmp.length() > 0 && Long.valueOf(tmp) > 0 ) {
                    urlTemplate = urlTemplate.queryParam("mlsNumber", "{mlsNumber}");
                    params.put("mlsNumber", tmp);
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_PARKING_COUNT)){
                String tmp = allParams.get(LogiqContant.LOGIC_PARKING_COUNT);
                if(tmp != null && tmp.length() > 0
                        && !tmp.equalsIgnoreCase("ANY")
                        && !tmp.equalsIgnoreCase("0+") ) {
                    urlTemplate = urlTemplate.queryParam("minParkingSpaces", "{minParkingSpaces}");
                    params.put("minParkingSpaces", Long.valueOf(tmp));
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_BEDROOM_COUNT)){
                String tmp = allParams.get(LogiqContant.LOGIC_BEDROOM_COUNT);
                if(tmp != null && tmp.length() > 0
                        && !tmp.equalsIgnoreCase("ANY")
                        && !tmp.equalsIgnoreCase("0+")  ) {
                    urlTemplate = urlTemplate.queryParam("minBeds", "{minBeds}");
                    params.put("minBeds", Integer.valueOf(tmp));
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_BATHROOM_COUNT)){
                String tmp = allParams.get(LogiqContant.LOGIC_BATHROOM_COUNT);
                if(tmp != null && tmp.length() > 0
                        && !tmp.equalsIgnoreCase("ANY")
                        && !tmp.equalsIgnoreCase("0+")  ) {
                    urlTemplate = urlTemplate.queryParam("minBaths", "{minBaths}");
                    params.put("minBaths", Integer.valueOf(tmp));
                }
            }
//            if(allParams.containsKey(LogiqContant.LOGIC_SQFT_MAX)){
//                String tmp = allParams.get(LogiqContant.LOGIC_SQFT_MAX);
//                if(tmp != null && tmp.length() > 0
//                        && !tmp.equalsIgnoreCase("ANY")
//                        && !tmp.equalsIgnoreCase("0+")
//                        && Long.valueOf(tmp) > 0) {
//                    urlTemplate = urlTemplate.queryParam("maxSqft", "{maxSqft}");
//                    params.put("maxSqft", Integer.valueOf(tmp));
//                }
//            }
            if(allParams.containsKey(LogiqContant.LOGIC_SQFT_MIN)){
                String tmp = allParams.get(LogiqContant.LOGIC_SQFT_MIN);
                if(tmp != null && tmp.length() > 0
                        && Long.valueOf(tmp) > 0
                        && !tmp.equalsIgnoreCase("ANY")
                        && !tmp.equalsIgnoreCase("0+")
                        && Long.valueOf(tmp) > 0) {
                    urlTemplate = urlTemplate.queryParam("minSqft", "{minSqft}");
                    params.put("minSqft", Integer.valueOf(tmp));
                }
            }
            if(allParams.containsKey(LogiqContant.LOGIC_WORD)){
                String tmp = allParams.get(LogiqContant.LOGIC_WORD);
                if(tmp != null && tmp.length() > 0
                        && !tmp.equalsIgnoreCase("ANY") ) {
                    while(tmp.length() < 3){
                        tmp += "*";
                    }
//                    urlTemplate = urlTemplate.queryParam("streetName", "{streetName}");
                    urlTemplate = urlTemplate.queryParam("keywords", "{keywords}");
                    params.put("keywords", tmp);
//                    params.put("streetName", tmp);
                }
            }
            if(fromMap){
                urlTemplate = urlTemplate.queryParam("fields", "{fields}");
                params.put("fields", "mlsNumber,map");
            }
            if(loginUser.isPresent()) {

                urlTemplate = urlTemplate.queryParam("status", "{statusU}");
                params.put("statusU", LogiqContant.RepliersConstant.Status.UNAVAILABLE.getName());

                Optional<List<Favorite>> favOfUser =  favoriteService.getFavoritesOfUserId(loginUser.get().getId());
                if(favOfUser.isPresent()) {
                    loginFavorits = favOfUser.get().stream()
                            .map(Favorite::getMlsNumber).collect(Collectors.toSet());

                    if (isfavorite) {
                        Optional<List<Favorite>> favorites = favoriteService.getFavoritesOfUserId(loginUser.get().getId());
                        if (favorites.isPresent()) {
                            for (Favorite f : favorites.get()) {
                                urlTemplate = urlTemplate.queryParam("mlsNumber", "{mlsNumber" + i + "}");
                                params.put("mlsNumber" + i, f.getMlsNumber());
                                i++;
                            }
                        }
                    }
                }
            }
        }
        urlTemplate = urlTemplate.queryParam("status", "{statusA}");
        params.put("statusA", LogiqContant.RepliersConstant.Status.AVAILABLE.getName());

        urlTemplate = urlTemplate.queryParam("sortBy", "{sortBy}");
        params.put("sortBy", LogiqContant.RepliersConstant.SortBy.UPDATED_ON_DESC.getName());
        String urlTemplateStr = urlTemplate.encode().toUriString();


        RepliersAds repliersAds = RepliersAds.builder().page(1L).numPages(0L).pageSize(10L).count(0L)
                .listings(new ArrayList<>()).build();
        if((loginFavorits.size() > 0 && isfavorite) || (!isfavorite) ) {
            ResponseEntity<RepliersAds> response = callRepliersGetService(headers,
                    params, urlTemplateStr, RepliersAds.class);
            repliersAds = response.getBody();
        }
        return LogiqConvertor.convertToAds(repliersAds,loginFavorits,fromMap);
    }

    private <T> ResponseEntity<T> callRepliersGetService(HttpHeaders headers, Map<String, Object> params,
                                                         String urlTemplateStr, Class resClass ) {
        LOGGER.debug("url is {}, parameters is {}, return class {}",
                urlTemplateStr, params, resClass.getName());
        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<?> request = new HttpEntity(headers);
        ResponseEntity<T> response = restTemplate.exchange(
                urlTemplateStr,
                HttpMethod.GET,
                request,
                resClass,
                params
        );
        return response;
    }

    private HttpHeaders getRepliersHeader() {
        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Arrays.asList(new MediaType[]{MediaType.APPLICATION_JSON}));
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set(LogiqContant.RepliersConstant.API_KEY, accessToken);
        return headers;
    }

    public LogiqAd getListingsByMlsNumber(String mlsNumber, Optional<User> loginUser) {
        LOGGER.debug("mlsNumber is : {}",mlsNumber);
        if (mlsNumber == null || mlsNumber.length() == 0) {
            throw new RuntimeException("invalid mlsnumber is received!!!...");
        }
        HttpHeaders headers = getRepliersHeader();
        var url = baseUrl + listings + "/" + mlsNumber;

        Map<String, Object> params = new HashMap<>();
        Set<String> loginFavorits = new HashSet<>();
        if(loginUser.isPresent()) {
            Optional<List<Favorite>> favOfUser = favoriteService.getFavoritesOfUserId(loginUser.get().getId());
            if (favOfUser.isPresent()) {
                loginFavorits = favOfUser.get().stream()
                        .map(Favorite::getMlsNumber).collect(Collectors.toSet());
            }
        }
        ResponseEntity<RepliersAd> response = callRepliersGetService(headers,
                params, url, RepliersAd.class);
        return LogiqConvertor.convertToAd(response.getBody(),loginFavorits);
    }

    public LogiqAds getListingsBaseOnGeos(List<Point> geos, Optional<User> loginUser) {
        return null;
    }
}
