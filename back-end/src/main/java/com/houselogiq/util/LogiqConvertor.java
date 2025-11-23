package com.houselogiq.util;

import com.houselogiq.data.ad.LogiqAd;
import com.houselogiq.data.ad.LogiqAds;
import com.houselogiq.data.ad.RepliersAd;
import com.houselogiq.data.ad.RepliersAds;
import lombok.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

public class LogiqConvertor {

    private static final Logger LOGGER = LoggerFactory.getLogger(LogiqConvertor.class);

    private LogiqConvertor() {
        throw new IllegalStateException();
    }

    public static LogiqAds convertToAds(RepliersAds body, Set<String> loginFavorits, boolean fromMap) {
        LogiqAds logiqAds = new LogiqAds();
        logiqAds.setPageCount(body.getNumPages());
        logiqAds.setPageSize(body.getPageSize());
        logiqAds.setThisPageEntriesCount(Long.valueOf(body.getListings().size()));
        logiqAds.setTotalEntriesCount(body.getCount());
        logiqAds.setPageIndex(body.getPage() - 1 );
        logiqAds.setResult(convert(body.getListings(), loginFavorits, fromMap));
        LOGGER.debug("number of items {}",logiqAds.getResult().size());
        return logiqAds;
    }

    public static LogiqAd convertToAd(RepliersAd body, Set<String> loginFavorits) {
        return convert(body, loginFavorits);
    }

    private static List<LogiqAd> convert(List<RepliersAd> listings, Set<String> loginFavorits, boolean fromMap) {
        List<LogiqAd> ads = new ArrayList<>();
        if(listings != null && listings.size() > 0){
            for(RepliersAd rd : listings){
                if(fromMap)
                    ads.add(convertMap(rd, loginFavorits));
                else
                    ads.add(convert(rd, loginFavorits));
            }
        }
        return  ads;
    }

    private static LogiqAd convertMap(RepliersAd rd, Set<String> loginFavorits){
        LogiqAd ad = new LogiqAd();
        ad.setId(rd.getMlsNumber());
        ad.setMlsNumber(rd.getMlsNumber());
        ad.setIsFavorite(loginFavorits.contains(rd.getMlsNumber()) ? true : false);
        if(rd.getMap() != null){
            ad.setLatitude(getOrDefaultNotSpecified(rd.getMap().getLatitude()));
            ad.setLongitude(getOrDefaultNotSpecified(rd.getMap().getLongitude()));
        }
        return ad;
    }

    private static LogiqAd convert(RepliersAd rd, Set<String> loginFavorits){
        LogiqAd ad = new LogiqAd();
        ad.setId(rd.getMlsNumber());
        ad.setMlsNumber(rd.getMlsNumber());
        ad.setPrice(getOrDefault(rd.getListPrice(), -1L));
        ad.setSoldPrice(getOrDefault(rd.getSoldPrice(), -1L));
        ad.setSoldDate(getOrDefault(rd.getSoldDate(),""));
        ad.setListDate(rd.getListDate());
        ad.setUpdatedOn(rd.getUpdatedOn());
        ad.setStatus(convertToStatus(rd.getLastStatus()));
        ad.setKlass(convertToClass(rd.getKlass()));
        ad.setType(convertToType(rd.getType()));

        ad.setIsFavorite(loginFavorits.contains(rd.getMlsNumber()) ? true : false);
        ad.setHistory(getOrDefault(null,""));
        if(rd.getDetails() != null) {
            ad.setPropertyType(convertToPropertyType(rd.getDetails().getPropertyType()));
            ad.setApproximateAge(getOrDefaultNotSpecified(rd.getDetails().getYearBuilt()));
            ad.setHasFirePlace(convertToCommonYesNoMapper(rd.getDetails().getNumFireplaces()));
            ad.setElevatorType(covertToElevatorType(rd.getDetails().getElevator()));
            ad.setHasElevator(convertToCommonYesNoMapper(rd.getDetails().getElevator()));
            ad.setHasCentralVacuum(convertToCommonYesNoMapper(rd.getDetails().getCentralVac()));
            ad.setSwimmingPool(convertToSwimmingPool(rd.getDetails().getSwimmingPool()));
            ad.setPropertyTypeStyle(convertToPropertyTypeStyle(rd.getDetails().getStyle()));
            ad.setExteriorConstruction1(convertToExteriorConstructionMapper(rd.getDetails().getExteriorConstruction1()));
            ad.setExteriorConstruction2(convertToExteriorConstructionMapper(rd.getDetails().getExteriorConstruction2()));
            ad.setGarage(convertToGarage(rd.getDetails().getGarage()));
            ad.setBasement1(convertToBasementMapper(rd.getDetails().getBasement1()));
            ad.setBasement2(convertToBasementMapper(rd.getDetails().getBasement2()));
            ad.setHeatSource(convertToHeatSource(rd.getDetails().getHeating()));
            ad.setHeatType(convertToHeatType(rd.getDetails().getHeating()));
            ad.setAirConditioning(convertToAirConditioning(rd.getDetails().getAirConditioning()));
            ad.setDescription(getOrDefaultNotSpecified(rd.getDetails().getDescription()));
            ad.setExtras(getOrDefaultNotSpecified(rd.getDetails().getExtras()));
            ad.setNumBathrooms(getOrDefault(rd.getDetails().getNumBathrooms(), -1L));
            ad.setNumBathroomsPlus(getOrDefault(rd.getDetails().getNumBathroomsPlus(), -1L));
            ad.setNumBedrooms(getOrDefault(rd.getDetails().getNumBedrooms(), -1L));
            ad.setNumBedroomsPlus(getOrDefault(rd.getDetails().getNumBedroomsPlus(), -1L));
            ad.setNumGarageSpaces(getOrDefault(rd.getDetails().getNumGarageSpaces(), -1L));
            ad.setNumParkingSpaces(getOrDefault(rd.getDetails().getNumParkingSpaces(), -1L));
            ad.setNumRooms(getOrDefault(rd.getDetails().getNumRooms(), -1L));
            ad.setNumRoomsPlus(getOrDefault(rd.getDetails().getNumRoomsPlus(), -1L));
            RangeDto range = convertToSquareFeet(rd.getDetails().getSqft());
            ad.setMaxSqFt(getOrDefault(range.getMax(),-1L));
            ad.setMinSqFt(getOrDefault(range.getMin(),-1L));
        }
        if(rd.getCondominium() != null){
            ad.setParkingType(convertToParkingType(rd.getCondominium().getParkingType()));
            ad.setExposure(convertToExposure(rd.getCondominium().getExposure()));
            ad.setLockerNumber(getOrDefaultNotSpecified(rd.getCondominium().getLockerNumber()));
            ad.setLocker(convertToLocker(rd.getCondominium().getLocker()));
            ad.setBuildingInfluencesList(convertToBuildingInfluencesList(rd.getCondominium().getAmmenities()));
            ad.setPetsPermitted(convertToCommonYesNoMapper(rd.getCondominium().getPets()));
            ad.setHasBuildingInsurance(convertToCommonYesNoMapper(rd.getCondominium().getBuildingInsurance()));
            if(rd.getCondominium().getFees() != null){
                ad.setCableIncludedInMaintenanceFees(convertToCommonYesNoMapper(rd.getCondominium().getFees().getCableInlc()));
                ad.setHeatIncludedInMaintenanceFees(convertToCommonYesNoMapper(rd.getCondominium().getFees().getHeatIncl()));
                ad.setHydroIncludedInMaintenanceFees(convertToCommonYesNoMapper(rd.getCondominium().getFees().getHydroIncl()));
                ad.setParkingIncludedInMaintenanceFees(convertToCommonYesNoMapper(rd.getCondominium().getFees().getParkingIncl()));
                ad.setTaxesIncludedInMaintenanceFees(convertToCommonYesNoMapper(rd.getCondominium().getFees().getTaxesIncl()));
                ad.setWaterIncludedInMaintenanceFees(convertToCommonYesNoMapper(rd.getCondominium().getFees().getWaterIncl()));
                ad.setMaintenanceFees(getOrDefault(rd.getCondominium().getFees().getMaintenance(),-1L));
            }
        }
        if(rd.getNearby() != null){
            ad.setAreaInfluencesList(convertToAreaInfluencesList(rd.getNearby().getAmmenities()));
        }
        if(rd.getOffice() != null){
            ad.setBrokerageName(getOrDefaultNotSpecified(rd.getOffice().getBrokerageName()));
        }
        if(rd.getImages() != null){
            ad.setImages(String.join(",",rd.getImages()));
        }
        if(rd.getAddress() != null){
            ad.setArea(getOrDefaultNotSpecified(rd.getAddress().getArea()));
            ad.setCity(getOrDefaultNotSpecified(rd.getAddress().getCity()));
            ad.setCountry(getOrDefaultNotSpecified(rd.getAddress().getCountry()));
            ad.setDistrict(getOrDefaultNotSpecified(rd.getAddress().getDistrict()));
            ad.setMajorIntersection(getOrDefaultNotSpecified(rd.getAddress().getMajorIntersection()));
            ad.setNeighborhood(getOrDefaultNotSpecified(rd.getAddress().getNeighborhood()));
            ad.setStreetDirection(getOrDefaultNotSpecified(rd.getAddress().getStreetDirection()));
            ad.setStreetName(getOrDefaultNotSpecified(rd.getAddress().getStreetName()));
            ad.setStreetNumber(getOrDefaultNotSpecified(rd.getAddress().getStreetNumber()));
            ad.setStreetSuffix(getOrDefaultNotSpecified(rd.getAddress().getStreetSuffix()));
            ad.setUnitNumber(getOrDefaultNotSpecified(rd.getAddress().getUnitNumber()));
            ad.setZip(getOrDefaultNotSpecified(rd.getAddress().getZip()));
            ad.setState(getOrDefaultNotSpecified(rd.getAddress().getState()));
        }
        if(rd.getMap() != null){
            ad.setLatitude(getOrDefaultNotSpecified(rd.getMap().getLatitude()));
            ad.setLongitude(getOrDefaultNotSpecified(rd.getMap().getLongitude()));
        }
        if(rd.getLot() != null){
            ad.setLotAcres(getOrDefaultNotSpecified(rd.getLot().getAcres()));
            ad.setLotDepth(getOrDefaultNotSpecified(rd.getLot().getDepth()));
            ad.setLotIrregular(getOrDefaultNotSpecified(rd.getLot().getIrregular()));
            ad.setLotWidth(getOrDefaultNotSpecified(rd.getLot().getWidth()));
            ad.setLotMeasurement(getOrDefaultNotSpecified(rd.getLot().getMeasurement()));
            ad.setLotLegalDescription(getOrDefaultNotSpecified(rd.getLot().getLegalDescription()));
        }
        if(rd.getPermissions() != null){
            ad.setDisplayAddressPermission(convertToCommonYesNoMapper(rd.getPermissions().getDisplayAddressOnInternet()));
            ad.setDisplayPublicPermission(convertToCommonYesNoMapper(rd.getPermissions().getDisplayPublic()));
        }
        if(rd.getTaxes() != null){
            ad.setTaxesAnnualAmount(getOrDefault(rd.getTaxes().getAnnualAmount(), -1.0F));
            ad.setTaxesAssessmentYear(getOrDefault(rd.getTaxes().getAssessmentYear(), -1L));
        }
        if(rd.getRooms() != null && rd.getRooms().size() > 0){
            for(String key : rd.getRooms().keySet()){
                RepliersAd.Room m = rd.getRooms().get(key);
                String roomDetail = convertToRoomDetail(key,m);
                switch (key){
                    case "1" : ad.setRoom1Details(roomDetail); break;
                    case "2" : ad.setRoom2Details(roomDetail); break;
                    case "3" : ad.setRoom3Details(roomDetail); break;
                    case "4" : ad.setRoom4Details(roomDetail); break;
                    case "5" : ad.setRoom5Details(roomDetail); break;
                    case "6" : ad.setRoom6Details(roomDetail); break;
                    case "7" : ad.setRoom7Details(roomDetail); break;
                    case "8" : ad.setRoom8Details(roomDetail); break;
                    case "9" : ad.setRoom9Details(roomDetail); break;
                    case "10" : ad.setRoom10Details(roomDetail); break;
                    case "11" : ad.setRoom11Details(roomDetail); break;
                    case "12" : ad.setRoom12Details(roomDetail); break;
                }
            }
        }
        return ad;
    }

    //TODO
    private static String convertToAreaInfluencesList(ArrayList<Object> tmp) {
        return "";
    }

    //TODO
    private static String convertToBuildingInfluencesList(List<Object> tmp) {
        return "";
    }

    private static String getOrDefaultNotSpecified(String value) {
        return (value != null && value.length() > 0) ? value : "NotSpecified";
    }

    private static String convertToRoomDetail(String key, RepliersAd.Room m) {
        StringBuilder room = new StringBuilder();
        String roomName = getOrDefaultNotSpecified(m.getDescription());
        String ftur1 = getOrDefaultNotSpecified(m.getFeatures());
        String ftur2 = getOrDefaultNotSpecified(m.getFeatures2());
        String ftur3 = getOrDefaultNotSpecified(m.getFeatures3());
        String features = "";
        if (ftur1 != null && !ftur1.isBlank() && ftur1 != "NotSpecified")
            features += ftur1.trim() + ",";
        if (ftur2 != null && !ftur2.isBlank() && ftur2 != "NotSpecified")
            features += ftur2.trim() + ",";
        if (ftur3 != null && !ftur3.isBlank() && ftur3 != "NotSpecified")
            features += ftur3.trim() + ",";
        Float lgth = 0.0F;
        Float wdth = 0.0F;
        try {
            lgth = Float.valueOf(m.getLength());
        }catch (Exception e){
        }
        try {
            wdth = Float.valueOf(m.getWidth());
        }catch (Exception e){

        }

        if (roomName != null && !roomName.isBlank() && roomName == "NotSpecified"
                && lgth == 0.0f && wdth == 0.0f){
//            room.append('\n');
            room.append("Room ").append(key).append(" ").append("Description : ");
//            room.append('\n');
//            room.append(" Description ").append(desc).append(" ");
            room.append('\n');
            room.append(" Room : ").append(roomName).append(" ");
            room.append('\n');
            room.append(" Length : ").append(lgth).append(" ");
            room.append('\n');
            room.append(" Width : ").append(wdth).append(" ");
            room.append('\n');
            room.append(" Features : ").append(features).append(" ");
//            room.append('\n');
        }
        return room.toString();
    }

    private static String convertToLocker(String tmp) {
        String map = null;
        if (tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Ensuite":
                    map = "Ensuite";
                    break;
                case "Owned":
                    map = "Owned";
                    break;
                case "None":
                    map = "None";
                    break;
                case "Ensuite+Owned":
                    map = "Ensuite+Owned";
                    break;
                case "Exclusive":
                    map = "Exclusive";
                    break;
                case "Common":
                    map = "Common";
                    break;
                case "Ensuite+Exclusive":
                    map = "Ensuite+Exclusive";
                    break;
                case "Ensuite+Common":
                    map = "Ensuite+Common";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToGeneralForm(String tmp) {
        String map = tmp/*.toLowerCase()
            .replace(" ","")
            .replace(",","")
            .replace("---","*")
            .replace("--","*")
            .replace("-","*")
            .replace("///","*")
            .replace("//","*")
            .replace("/","*")
            .replace("+","*")*/;
        return map;
    }

    private static String convertToExposure(String tmp) {
        String map = null;
        if (tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "W":
                    map = "West";
                    break;
                case "S":
                    map = "South";
                    break;
                case "Sw":
                    map = "South West";
                    break;
                case "N":
                    map = "North";
                    break;
                case "Se":
                    map = "South East";
                    break;
                case "E":
                    map = "East";
                    break;
                case "Nw":
                    map = "North West";
                    break;
                case "Ne":
                    map = "North East";
                    break;
                case "Ew":
                    map = "East West";
                    break;
                case "Ns":
                    map = "North South";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToParkingType(String tmp) {
        String map = null;
        if (tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Exclusive":
                    map = "Exclusive";
                    break;
                case "Owned":
                    map = "Owned";
                    break;
                case "Common":
                    map = "Common";
                    break;
                case "None":
                    map = "None";
                    break;
                case "Rental":
                    map = "Rental";
                    break;
                case "Stacked":
                    map = "Stacked";
                    break;
                case "Compact":
                    map = "Compact";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    @Data
    public static class RangeDto{
        private String min = null;
        private String max = null;
    }

    private static RangeDto convertToSquareFeet(String tmp) {
        RangeDto map = new RangeDto();
        if(tmp != null && tmp.length() > 0){
            String split[] = tmp.split("-");
            if(split != null)
                if(split.length > 0 && split[0] != null && split[0].length() > 0)
                    map.min = /*Float.valueOf(*/split[0]/*)*/;
                if(split.length > 1 && split[1] != null && split[0].length() > 0)
                    map.max = /*Float.valueOf(*/split[1]/*)*/;
        }
        return map;
    }

    private static String getOrDefault(String tmp, String defaultValue) {
        String map = defaultValue;
        if(tmp != null && tmp.length() > 0) {
            tmp = removeSpecialCharFromDecimal(tmp);
            map = tmp;
        }
        return map;
    }

    private static Long getOrDefault(String tmp, Long defaultValue) {
        Long map = defaultValue;
        if(tmp != null && tmp.length() > 0) {
            tmp = removeSpecialCharFromDecimal(tmp);
            map = Float.valueOf(tmp).longValue();
        }
        return map;
    }

    private static String removeSpecialCharFromDecimal(String tmp) {
        return tmp.replaceAll("<","")
                .replaceAll(">","")
                .replaceAll("\\+","")
                .replaceAll("\\*","").trim();
    }

    private static Float getOrDefault(String tmp, Float defaultValue) {
        Float map = defaultValue;
        if(tmp != null && tmp.length() > 0){
            tmp = removeSpecialCharFromDecimal(tmp);
            map = Float.valueOf(tmp);
        }
        return map;
    }

    private static String convertToAirConditioning(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Central Air":
                    map = "Central Air";
                    break;
                case "None":
                    map = "None";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "Wall Unit":
                    map = "Wall Unit";
                    break;
                case "Window Unit":
                    map = "Window Unit";
                    break;
                case "Y":
                    map = "NotSpecified";
                    break;
                case "N":
                    map = "None";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToHeatType(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Forced Air":
                    map = "Forced Air";
                    break;
                case "Water":
                    map = "Water";
                    break;
                case "Radiant":
                    map = "Radiant";
                    break;
                case "Heat Pump":
                    map = "Heat Pump";
                    break;
                case "Baseboard":
                    map = "Baseboard";
                    break;
                case "Fan Coil":
                    map = "Fan Coil";
                    break;
                case "Hot Water":
                    map = "Hot Water";
                    break;
                case "Water Radiators":
                    map = "Water Radiators";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "None":
                    map = "None";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToHeatSource(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Elec":
                    map = "Electric";
                    break;
                case "Gas":
                    map = "Gas";
                    break;
                case "Propane":
                    map = "Propane";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "None":
                    map = "None";
                    break;
                case "Oil":
                    map = "Oil";
                    break;
                case "Ground Source":
                    map = "Ground Source";
                    break;
                case "Solar":
                    map = "Solar";
                    break;
                case "Wood":
                    map = "Wood";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToBasementMapper(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Apartment":
                    map = "Apartment";
                    break;
                case "Crawl Space":
                    map = "Crawl Space";
                    break;
                case "Finished":
                    map = "Finished";
                    break;
                case "Fin W/O":
                    map = "Finished with Walk-Out";
                    break;
                case "Full":
                    map = "Full";
                    break;
                case "Half":
                    map = "Half";
                    break;
                case "None":
                case "N":
                    map = "None";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "Part Bsmt":
                    map = "Partial Basement";
                    break;
                case "Part Fin":
                    map = "Partially Finished";
                    break;
                case "Sep Entrance":
                    map = "Separate Entrance";
                    break;
                case "Unfinished":
                    map = "Unfinished";
                    break;
                case "W/O":
                    map = "Walk-Out";
                    break;
                case "Walk-Up":
                    map = "Walk-Up";
                    break;
                case "Y":
                    map = "NotSpecified";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToGarage(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Undergrnd":
                case "Underground":
                    map = "Underground";
                    break;

                //repliers did have these values, but hallmark forms did not
                case "None":
                    map = "None";
                    break;
                case "Attached":
                    map = "Attached";
                    break;
                case "Built-In":
                    map = "Built-In";
                    break;
                case "Surface":
                    map = "Surface";
                    break;
                case "Detached":
                    map = "Detached";
                    break;
                case "Carport":
                    map = "Carport";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "Outside/Surface":
                    map = "Outside/Surface";
                    break;
                case "Public":
                    map = "Public";
                    break;
                case "Plaza":
                    map = "Plaza";
                    break;
                case "Visitor":
                    map = "Visitor";
                    break;
                case "Reserved/Assignd":
                    map = "Reserved/Assigned";
                    break;
                case "Street":
                    map = "Street";
                    break;
                case "Boulevard":
                    map = "Boulevard";
                    break;
                case "Pay":
                    map = "Pay";
                    break;
                case "Double Detached":
                    map = "Double Detached";
                    break;
                case "Covered":
                    map = "Covered";
                    break;
                case "In/Out":
                    map = "In/Out";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToExteriorConstructionMapper(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Alum Siding":
                    map = "Aluminum Siding";
                    break;
                case "Board/Batten":
                    map = "Board & Batten";
                    break;
                case "Brick":
                    map = "Brick";
                    break;
                case "Brick Front":
                    map = "Brick Front";
                    break;
                case "Concrete":
                    map = "Concrete";
                    break;
                case "Insulbrick":
                    map = "Insulbrick";
                    break;
                case "Log":
                    map = "Log";
                    break;
                case "Metal/Side":
                    map = "Metal/Steel Siding";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "Shingle":
                    map = "Shingle";
                    break;
                case "Stone":
                    map = "Stone";
                    break;
                case "Stucco/Plaster":
                    map = "Stucco (Plaster)";
                    break;
                case "Vinyl Siding":
                    map = "Vinyl Siding";
                    break;
                case "Wood":
                    map = "Wood";
                    break;
                case "None":
                    map = "None";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToPropertyTypeStyle(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "2-Storey":
                    map = "2-Storey";
                    break;
                case "3-Storey":
                    map = "3-Storey";
                    break;
                case "Apartment":
                    map = "Apartment";
                    break;
                case "Bachelor/Studio":
                    map = "Bachelor/Studio";
                    break;
                case "Bungaloft":
                    map = "Bungaloft";
                    break;
                case "Bungalow":
                    map = "Bungalow";
                    break;
                case "Loft":
                    map = "Loft";
                    break;
                case "Multi-Level":
                    map = "Multi-Level";
                    break;
                case "Stacked Townhse":
                    map = "Stacked Townhouse";
                    break;
                case "1 1/2 Storey":
                    map = "1 1/2 Storey";
                    break;
                case "2 1/2 Storey":
                    map = "2 1/2 Storey";
                    break;
                case "Backsplit 3":
                    map = "Backsplit 3 Level";
                    break;
                case "Backsplit 4":
                    map = "Backsplit 4 Level";
                    break;
                case "Backsplit 5":
                    map = "Backsplit 5 Level";
                    break;
                case "Bungalow-Raised":
                    map = "Bungalow-Raised";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "Sidesplit 3":
                    map = "Sidesplit 3 Level";
                    break;
                case "Sidesplit 4":
                    map = "Sidesplit 4 Level";
                    break;
                case "Sidesplit 5":
                    map = "Sidesplit 5 Level";
                    break;
                case "Industrial Loft":
                    map = "Industrial Loft";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToSwimmingPool(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "None":
                    map = "None";
                    break;
                case "Inground":
                    map = "Inground";
                    break;
                case "Indoor":
                    map = "Indoor";
                    break;
                case "Abv Grnd":
                    map = "Above Ground";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String covertToElevatorType(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Frt+Pub":
                    map = "Frt+Pub";
                    break;
                case "Public":
                    map = "Public";
                    break;
                case "N":
                case "No":
                case "Non":
                case "None":
                    map = "None";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToCommonYesNoMapper(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Restrict":
                case "No":
                case "N":
                case "None":
                case "Non":
                    map = "No";
                    break;
                case "Y":
                case "Yes":
                    map = "Yes";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String convertToPropertyType(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Att/Row/Twnhouse":
                    map = "Attached/Row/Street Townhouse";
                    break;
                case "Cottage":
                    map = "Cottage";
                    break;
                case "Detached":
                    map = "Detached";
                    break;
                case "Duplex":
                    map = "Duplex";
                    break;
                case "Farm":
                    map = "Farm";
                    break;
                case "Fourplex":
                    map = "Fourplex";
                    break;
                case "Link":
                    map = "Link";
                    break;
                case "Mobile/Trailer":
                    map = "Mobile/Trailer";
                    break;
                case "Multiplex":
                    map = "Multiplex";
                    break;
                case "Rural Resid":
                    map = "Rural Residential";
                    break;
                case "Semi-Detached":
                    map = "Semi-Detached";
                    break;
                case "Store W/Apt/Offc":
                    map = "Store with Apt/Office";
                    break;
                case "Store W/Apt/Office":
                    map = "Store with Apt/Office";
                    break;
                case "Triplex":
                    map = "Triplex";
                    break;
                case "Vacant Land":
                    map = "Vacant Land";
                    break;
                case "Comm Element Condo":
                    map = "Common Element Condo";
                    break;
                case "Condo Apt":
                    map = "Condo Apartment";
                    break;
                case "Condo Townhouse":
                    map = "Condo Townhouse";
                    break;
                case "Co-Op Apt":
                    map = "Co-Op Apartment";
                    break;
                case "Co-Ownership Apt":
                    map = "Co-Ownership Apartment";
                    break;
                case "Det Condo":
                    map = "Detached Condo";
                    break;
                case "Leasehold Condo":
                    map = "Leasehold Condo";
                    break;
                case "Locker":
                    map = "Locker";
                    break;
                case "Other":
                    map = "Other";
                    break;
                case "Parking Space":
                    map = "Parking Space";
                    break;

                //repliers did not have these values, but hallmark forms did
                case "Detached with Common Elements":
                    map = "Detached with Common Elements";
                    break;
                case "Phased Condo":
                    map = "Phased Condo";
                    break;
                case "Semi-Detached Condo":
                    map = "Semi-Detached Condo";
                    break;
                case "Time Share":
                    map = "Time Share";
                    break;
                case "Vacant Land Condo":
                    map = "Vacant Land Condo";
                    break;

                //repliers did have these values, but hallmark forms did not
                case "Industrial":
                    map = "Industrial";
                    break;
                case "Upper Level":
                    map = "Upper Level";
                    break;
                case "Room":
                    map = "Room";
                    break;
                case "Lower Level":
                    map = "Lower Level";
                    break;
                case "Shared Room":
                    map = "Shared Room";
                    break;
                case "Sale Of Business":
                    map = "Sale Of Business";
                    break;
                case "Commercial/Retail":
                    map = "Commercial/Retail";
                    break;
                case "Office":
                    map = "Office";
                    break;
                case "Land":
                    map = "Land";
                    break;
                case "Investment":
                    map = "Investment";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    public static String convertFromClass(String tmp) {
        String map = null;
        if(tmp != null) {
            switch (tmp) {
                case "Commercial":
                    map = "commercial";
                    break;
                case "Condo":
                    map = "condo";
                    break;
                case "Residential":
                    map = "residential";
                    break;
            }
        }
        return map;
    }

    public static String convertToClass(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "CommercialProperty":
                    map = "Commercial";
                    break;
                case "CondoProperty":
                    map = "Condo";
                    break;
                case "ResidentialProperty":
                    map = "Residential";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    public static String convertFromType(String tmp) {
        String map = null;
        if(tmp != null) {
            switch (tmp) {
                case "Lease":
                    map = "lease";
                    break;
                case "Sale":
                    map = "sale";
                    break;
            }
        }
        return map;
    }

    public static String convertToType(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Lease":
                    map = "Lease";
                    break;
                case "Sale":
                    map = "Sale";
                    break;
                default:
                    map = "Unknown" + (checkUnknownValue(tmp));
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    public static List<String> getAnonymousStatus() {
        return Collections.unmodifiableList(Arrays.asList("Sus","Exp","Dft","Sc","Lc","Pc","Ext","Ter","Lsd","New"));
    }

    public static String convertFromStatus(String tmp) {
        String map = null;
        if(tmp != null) {
            switch (tmp) {
                case "Suspended":
                    map = "Sus";
                    break;
                case "Expired":
                    map = "Exp";
                    break;
                case "Sold":
                    map = "Sld";
                    break;
                case "Deal Fell Through":
                    map = "Dft";
                    break;
                case "Sold Conditionally":
                    map = "Sc";
                    break;
                case "Leased Conditionally":
                    map = "Lc";
                    break;
                case "Price Change":
                    map = "Pc";
                    break;
                case "Extended":
                    map = "Ext";
                    break;
                case "Terminated":
                    map = "Ter";
                    break;
                case "Leased":
                    map = "Lsd";
                    break;
                case "New":
                    map = "New";
                    break;
            }
        }
        return map;
    }

    public static String convertToStatus(String tmp) {
        String map = null;
        if(tmp != null && tmp.length() > 0) {
            tmp = convertToGeneralForm(tmp);
            switch (tmp) {
                case "Sus":
                    map = "Suspended";
                    break;
                case "Exp":
                    map = "Expired";
                    break;
                case "Sld":
                    map = "Sold";
                    break;
                case "Dft":
                    map = "Deal Fell Through";
                    break;
                case "Sc":
                    map = "Sold Conditionally";
                    break;
                case "Lc":
                    map = "Leased Conditionally";
                    break;
                case "Pc":
                    map = "Price Change";
                    break;
                case "Ext":
                    map = "Extended";
                    break;
                case "Ter":
                    map = "Terminated";
                    break;
                case "Lsd":
                    map = "Leased";
                    break;
                case "New":
                    map = "New";
                    break;
                default:
                    map = "Unknown" + checkUnknownValue(tmp);
                    break;
            }
        } else {
            map = "NotSpecified";
        }
        return map;
    }

    private static String checkUnknownValue(String tmp) {
        return (tmp != null && tmp.length() > 0) ? "-" + tmp : "";
    }
}
