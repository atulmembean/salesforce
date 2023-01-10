/**
* Class Type     	: Service Class
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : All the 'Country Settings' Custom Setting specific SOQLs and Operations are written in this class.
**/
public class CountrySettingsService {
    
    public static Map<String, Country_Settings__c> allCountriesSettingsMap {
        get {
            if(allCountriesSettingsMap == NULL) {
                allCountriesSettingsMap = new Map<String, Country_Settings__c>();
                List<Country_Settings__c> allCountriesSettings = getAllCountriesSettings();
                if(allCountriesSettings != null && !allCountriesSettings.isEmpty()) {
                    for(Country_Settings__c cs : allCountriesSettings) {
                        allCountriesSettingsMap.put(cs.Country__c, cs);
                    }
                }
            }
            return allCountriesSettingsMap;
        }
    }
    
    public static Country_Settings__c getCountrySettingsByCountry(String countryName) {
        try {
            return [Select Id, Name, Country__c, Academic_Year_Start_Month__c, Academic_Year_End_Month__c, 
                    Academic_Year_Start_Month_Num__c, Academic_Year_End_Month_Num__c 
                    from Country_Settings__c 
                    where Country__c = :countryName];
        } catch(Exception e) {
            return null;
        }
    }
    
    public static List<Country_Settings__c> getAllCountriesSettings() {
        try {
            return [Select Id, Name, Country__c, Academic_Year_Start_Month__c, Academic_Year_End_Month__c, 
                    Academic_Year_Start_Month_Num__c, Academic_Year_End_Month_Num__c 
                    from Country_Settings__c];
        } catch(Exception e) {
            return null;
        }
    }
    
    public static Integer getCurrentAcademicStartYear(String countryName) {
        if(allCountriesSettingsMap != NULL && allCountriesSettingsMap.containsKey(countryName)) {
            Country_Settings__c academicYear = allCountriesSettingsMap.get(countryName);
            if(academicYear.Academic_Year_Start_Month_Num__c <= Date.today().month()) {
                return Date.today().year();
            } else {
                return Date.today().year()-1;
            }
        } else {
            return Date.today().year();
        }
    }
}