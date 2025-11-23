package com.houselogiq.data.ad;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonRootName;
import lombok.Data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Data
public class RepliersAd {
    private String listDate;
    private Map<String,Room> rooms = new HashMap<>();
    private String originalPrice = null;
    private String soldDate = null;
    private String occupancy;
    private Timestamps timestamps;
    private Condominium condominium;
    private Taxes taxes;
    private Office office;
    private String type;
    private Nearby nearby;
    private Lot lot;
    private String mlsNumber;
    private Map<String,OpenHouseMap> openHouse = new HashMap();
    private Permissions permissions;
    private String soldPrice;
    private Details details;
    @JsonProperty("class")
    private String klass;
    private RepliersAd.MapObject map;
    private List<String> images = new ArrayList<String>();
    private Address address;
    private String resource;
    private String updatedOn;
    private String daysOnMarket;
    private List<Object> agents = new ArrayList<Object>();
    private String listPrice;
    private String lastStatus;
    private String status;
    private Long boardId;

    @Data
    public static class Address {
        private String area;
        private String zip;
        private String country = null;
        private String city;
        private String streetNumber;
        private String unitNumber;
        private String streetDirection;
        private String streetName;
        private String district;
        private String streetSuffix;
        private String neighborhood;
        private String state;
        private String majorIntersection;
        private String communityCode = null;

    }

    @Data
    @JsonRootName("map")
    public static class MapObject {
        private String latitude;
        private String point;
        private String longitude;
    }

    @Data
    public static class Details {
        private String numParkingSpaces;
        private String laundryLevel = null;
        private String zoningDescription = null;
        private String moreInformationLink = null;
        private String certificationLevel = null;
        private String den;
        private String yearBuilt;
        private String balcony;
        private String alternateURLVideoLink = null;
        private String exteriorConstruction1;
        private String elevator;
        private String exteriorConstruction2;
        private String roofMaterial = null;
        private String zoning = null;
        private String basement1;
        private String basement2;
        private String sqft;
        private String handicappedEquipped = null;
        private String heating;
        private String numRooms;
        private String landscapeFeatures = null;
        private String virtualTourUrl;
        private String landSewer = null;
        private String energyCertification = null;
        private String numBathrooms;
        private String greenPropertyInformationStatement = null;
        private String liveStreamEventURL = null;
        private String zoningType = null;
        private String landAccessType = null;
        private String businessSubType = null;
        private String swimmingPool = null;
        private String constructionStyleSplitLevel = null;
        private String leaseTerms = null;
        private String numRoomsPlus;
        private String flooringType = null;
        private String farmType = null;
        private String landDisposition = null;
        private String viewType = null;
        private String style;
        private String loadingType = null;
        private String numGarageSpaces;
        private String parkCostMonthly = null;
        private String airConditioning;
        private String familyRoom = null;
        private String constructionStatus = null;
        private String numBedrooms;
        private String description;
        private String extras;
        private String patio;
        private String amperage = null;
        private String centralAirConditioning = null;
        private String furnished;
        private String foundationType = null;
        private String sewer = null;
        private String propertyType;
        private String commonElementsIncluded = null;
        private String numBathroomsPlus = null;
        private String ceilingType = null;
        private String numBedroomsPlus;
        private String garage;
        private String centralVac;
        private String driveway = null;
        private String numFireplaces;
        private String energuideRating = null;
        private String fireProtection = null;
        private String storageType = null;
        private String analyticsClick = null;
        private String businessType = null;
        private String numBathroomsHalf = null;
    }

    @Data
    public static class Permissions {
        private String displayAddressOnInternet;
        private String displayPublic;
    }

    @Data
    public static class OpenHouseMap{
        private String date;
        private String startTime;
        private String endTime;
    }

    @Data
    public static class Lot {
        private String depth = null;
        private String width = null;
        private String irregular = null;
        private String acres = null;
        private String legalDescription = null;
        private String measurement = null;
    }

    @Data
    public static class Nearby {
        ArrayList<Object> ammenities = new ArrayList<Object>();
    }

    @Data
    public static class Office {
        private String brokerageName;
    }

    @Data
    public static class Taxes {
        private String annualAmount;
        private String assessmentYear;
    }

    @Data
    public static class Condominium {
        private String pets;
        private String condoCorpNum;
        private String parkingType;
        private Fees fees;
        private String stories;
        private String propertyMgr;
        private String lockerLevel = null;
        private String unitNumber = null;
        private String buildingInsurance;
        private String locker;
        private String condoCorp;
        private String sharesPercentage = null;
        private String ensuiteLaundry = null;
        private String exposure;
        private String lockerNumber;
        private String lockerUnitNumber = null;
        private List<Object> ammenities = new ArrayList<Object>();
    }

    @Data
    public static class Fees {
        private String cableInlc;
        private String waterIncl;
        private String heatIncl;
        private String taxesIncl;
        private String parkingIncl;
        private String maintenance;
        private String hydroIncl;
    }

    @Data
    public static class Timestamps {
        private String expiryDate;
        private String terminatedDate = null;
        private String listingEntryDate;
        private String closedDate = null;
        private String possessionDate = null;
        private String idxUpdated = null;
        private String conditionalExpiryDate = null;
        private String listingUpdated;
        private String photosUpdated;
        private String suspendedDate = null;
        private String extensionEntryDate = null;
        private String unavailableDate = null;
    }

    @Data
    public static class Room{
        private String features;
        private String level = null;
        private String length;
        private String width;
        private String description;
        private String features3;
        private String features2;
    }
}



