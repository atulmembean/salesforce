@isTest
private class CountrySettingsTest {
    
    static testMethod void countrySettingsTest() {
        
        CountrySettingsService.getAllCountriesSettings();
        
        Country_Settings__c usaSettings = new Country_Settings__c();
        usaSettings.Country__c = 'US';
        usaSettings.Academic_Year_Start_Month__c = 'August';
        usaSettings.Academic_Year_End_Month__c = 'July';
        insert usaSettings;
        
        CountrySettingsService.getCountrySettingsByCountry('US');
        CountrySettingsService.getAllCountriesSettings();
        CountrySettingsService.getCurrentAcademicStartYear('US');
        CountrySettingsService.getCurrentAcademicStartYear(null);
        CountrySettingsService.getCountrySettingsByCountry(null);
    }
}