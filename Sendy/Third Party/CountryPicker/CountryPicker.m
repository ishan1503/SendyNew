//
//  CountryPicker.m
//
//  Version 1.2.3
//
//  Created by Nick Lockwood on 25/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/CountryPicker
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  The source code and data files in this project are the sole creation of
//  Charcoal Design and are free for use subject to the terms below. The flag
//  icons were sourced from https://github.com/koppi/iso-country-flags-svg-collection
//  and are available under a Public Domain license
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "CountryPicker.h"


#pragma GCC diagnostic ignored "-Wselector"
#pragma GCC diagnostic ignored "-Wgnu"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@interface CountryPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end


@implementation CountryPicker

//doesn't use _ prefix to avoid name clash with superclass
@synthesize delegate;
+(NSArray *)getCountryCode:(NSString *)code
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:
                        @[@"Afghanistan",@"93"],@"AF",
                        @[@"Aland Islands",@"358"],@"AX",
                        @[@"Albania",@"355"],@"AL",
                        @[@"Algeria",@"213"],@"DZ",
                        @[@"American Samoa",@"1"],@"AS",
                        @[@"Andorra",@"376"],@"AD",
                        @[@"Angola",@"244"],@"AO",
                        @[@"Anguilla",@"1"],@"AI",
                        @[@"Antarctica",@"672"],@"AQ",
                        @[@"Antigua and Barbuda",@"1"],@"AG",
                        @[@"Argentina",@"54"],@"AR",
                        @[@"Armenia",@"374"],@"AM",
                        @[@"Aruba",@"297"],@"AW",
                        @[@"Australia",@"61"],@"AU",
                        @[@"Austria",@"43"],@"AT",
                        @[@"Azerbaijan",@"994"],@"AZ",
                        @[@"Bahamas",@"1"],@"BS",
                        @[@"Bahrain",@"973"],@"BH",
                        @[@"Bangladesh",@"880"],@"BD",
                        @[@"Barbados",@"1"],@"BB",
                        @[@"Belarus",@"375"],@"BY",
                        @[@"Belgium",@"32"],@"BE",
                        @[@"Belize",@"501"],@"BZ",
                        @[@"Benin",@"229"],@"BJ",
                        @[@"Bermuda",@"1"],@"BM",
                        @[@"Bhutan",@"975"],@"BT",
                        @[@"Bolivia",@"591"],@"BO",
                        @[@"Bosnia and Herzegovina",@"387"],@"BA",
                        @[@"Botswana",@"267"],@"BW",
                        @[@"Bouvet Island",@"47"],@"BV",
                        @[@"BQ",@"599"],@"BQ",
                        @[@"Brazil",@"55"],@"BR",
                        @[@"British Indian Ocean Territory",@"246"],@"IO",
                        @[@"British Virgin Islands",@"1"],@"VG",
                        @[@"Brunei Darussalam",@"673"],@"BN",
                        @[@"Bulgaria",@"359"],@"BG",
                        @[@"Burkina Faso",@"226"],@"BF",
                        @[@"Burundi",@"257"],@"BI",
                        @[@"Cambodia",@"855"],@"KH",
                        @[@"Cameroon",@"237"],@"CM",
                        @[@"Canada",@"1"],@"CA",
                        @[@"Cape Verde",@"238"],@"CV",
                        @[@"Cayman Islands",@"345"],@"KY",
                        @[@"Central African Republic",@"236"],@"CF",
                        @[@"Chad",@"235"],@"TD",
                        @[@"Chile",@"56"],@"CL",
                        @[@"China",@"86"],@"CN",
                        @[@"Christmas Island",@"61"],@"CX",
                        @[@"Cocos (Keeling) Islands",@"61"],@"CC",
                        @[@"Colombia",@"57"],@"CO",
                        @[@"Comoros",@"269"],@"KM",
                        @[@"Congo (Brazzaville)",@"242"],@"CG",
                        @[@"Congo, Democratic Republic of the",@"243"],@"CD",
                        @[@"Cook Islands",@"682"],@"CK",
                        @[@"Costa Rica",@"506"],@"CR",
                        @[@"Côte d'Ivoire",@"225"],@"CI",
                        @[@"Croatia",@"385"],@"HR",
                        @[@"Cuba",@"53"],@"CU",
                        @[@"Curacao",@"599"],@"CW",
                        @[@"Cyprus",@"537"],@"CY",
                        @[@"Czech Republic",@"420"],@"CZ",
                        @[@"Denmark",@"45"],@"DK",
                        @[@"Djibouti",@"253"],@"DJ",
                        @[@"Dominica",@"1"],@"DM",
                        @[@"Dominican Republic",@"1"],@"DO",
                        @[@"Ecuador",@"593"],@"EC",
                        @[@"Egypt",@"20"],@"EG",
                        @[@"El Salvador",@"503"],@"SV",
                        @[@"Equatorial Guinea",@"240"],@"GQ",
                        @[@"Eritrea",@"291"],@"ER",
                        @[@"Estonia",@"372"],@"EE",
                        @[@"Ethiopia",@"251"],@"ET",
                        @[@"Falkland Islands (Malvinas)",@"500"],@"FK",
                        @[@"Faroe Islands",@"298"],@"FO",
                        @[@"Fiji",@"679"],@"FJ",
                        @[@"Finland",@"358"],@"FI",
                        @[@"France",@"33"],@"FR",
                        @[@"French Guiana",@"594"],@"GF",
                        @[@"French Polynesia",@"689"],@"PF",
                        @[@"French Southern Territories",@"689"],@"TF",
                        @[@"Gabon",@"241"],@"GA",
                        @[@"Gambia",@"220"],@"GM",
                        @[@"Georgia",@"995"],@"GE",
                        @[@"Germany",@"49"],@"DE",
                        @[@"Ghana",@"233"],@"GH",
                        @[@"Gibraltar",@"350"],@"GI",
                        @[@"Greece",@"30"],@"GR",
                        @[@"Greenland",@"299"],@"GL",
                        @[@"Grenada",@"1"],@"GD",
                        @[@"Guadeloupe",@"590"],@"GP",
                        @[@"Guam",@"1"],@"GU",
                        @[@"Guatemala",@"502"],@"GT",
                        @[@"Guernsey",@"44"],@"GG",
                        @[@"Guinea",@"224"],@"GN",
                        @[@"Guinea-Bissau",@"245"],@"GW",
                        @[@"Guyana",@"595"],@"GY",
                        @[@"Haiti",@"509"],@"HT",
                        @[@"Holy See (Vatican City State)",@"379"],@"VA",
                        @[@"Honduras",@"504"],@"HN",
                        @[@"Hong Kong, Special Administrative Region of China",@"852"],@"HK",
                        @[@"Hungary",@"36"],@"HU",
                        @[@"Iceland",@"354"],@"IS",
                        @[@"India",@"91"],@"IN",
                        @[@"Indonesia",@"62"],@"ID",
                        @[@"Iran, Islamic Republic of",@"98"],@"IR",
                        @[@"Iraq",@"964"],@"IQ",
                        @[@"Ireland",@"353"],@"IE",
                        @[@"Isle of Man",@"44"],@"IM",
                        @[@"Israel",@"972"],@"IL",
                        @[@"Italy",@"39"],@"IT",
                        @[@"Jamaica",@"1"],@"JM",
                        @[@"Japan",@"81"],@"JP",
                        @[@"Jersey",@"44"],@"JE",
                        @[@"Jordan",@"962"],@"JO",
                        @[@"Kazakhstan",@"77"],@"KZ",
                        @[@"Kenya",@"254"],@"KE",
                        @[@"Kiribati",@"686"],@"KI",
                        @[@"Korea, Democratic People's Republic of",@"850"],@"KP",
                        @[@"Korea, Republic of",@"82"],@"KR",
                        @[@"Kuwait",@"965"],@"KW",
                        @[@"Kyrgyzstan",@"996"],@"KG",
                        @[@"Lao PDR",@"856"],@"LA",
                        @[@"Latvia",@"371"],@"LV",
                        @[@"Lebanon",@"961"],@"LB",
                        @[@"Lesotho",@"266"],@"LS",
                        @[@"Liberia",@"231"],@"LR",
                        @[@"Libya",@"218"],@"LY",
                        @[@"Liechtenstein",@"423"],@"LI",
                        @[@"Lithuania",@"370"],@"LT",
                        @[@"Luxembourg",@"352"],@"LU",
                        @[@"Macao, Special Administrative Region of China",@"853"],@"MO",
                        @[@"Macedonia, Republic of",@"389"],@"MK",
                        @[@"Madagascar",@"261"],@"MG",
                        @[@"Malawi",@"265"],@"MW",
                        @[@"Malaysia",@"60"],@"MY",
                        @[@"Maldives",@"960"],@"MV",
                        @[@"Mali",@"223"],@"ML",
                        @[@"Malta",@"356"],@"MT",
                        @[@"Marshall Islands",@"692"],@"MH",
                        @[@"Martinique",@"596"],@"MQ",
                        @[@"Mauritania",@"222"],@"MR",
                        @[@"Mauritius",@"230"],@"MU",
                        @[@"Mayotte",@"262"],@"YT",
                        @[@"Mexico",@"52"],@"MX",
                        @[@"Micronesia, Federated States of",@"691"],@"FM",
                        @[@"Moldova",@"373"],@"MD",
                        @[@"Monaco",@"377"],@"MC",
                        @[@"Mongolia",@"976"],@"MN",
                        @[@"Montenegro",@"382"],@"ME",
                        @[@"Montserrat",@"1"],@"MS",
                        @[@"Morocco",@"212"],@"MA",
                        @[@"Mozambique",@"258"],@"MZ",
                        @[@"Myanmar",@"95"],@"MM",
                        @[@"Namibia",@"264"],@"NA",
                        @[@"Nauru",@"674"],@"NR",
                        @[@"Nepal",@"977"],@"NP",
                        @[@"Netherlands",@"31"],@"NL",
                        @[@"Netherlands Antilles",@"599"],@"AN",
                        @[@"New Caledonia",@"687"],@"NC",
                        @[@"New Zealand",@"64"],@"NZ",
                        @[@"Nicaragua",@"505"],@"NI",
                        @[@"Niger",@"227"],@"NE",
                        @[@"Nigeria",@"234"],@"NG",
                        @[@"Niue",@"683"],@"NU",
                        @[@"Norfolk Island",@"672"],@"NF",
                        @[@"Northern Mariana Islands",@"1"],@"MP",
                        @[@"Norway",@"47"],@"NO",
                        @[@"Oman",@"968"],@"OM",
                        @[@"Pakistan",@"92"],@"PK",
                        @[@"Palau",@"680"],@"PW",
                        @[@"Palestinian Territory, Occupied",@"970"],@"PS",
                        @[@"Panama",@"507"],@"PA",
                        @[@"Papua New Guinea",@"675"],@"PG",
                        @[@"Paraguay",@"595"],@"PY",
                        @[@"Peru",@"51"],@"PE",
                        @[@"Philippines",@"63"],@"PH",
                        @[@"Pitcairn",@"872"],@"PN",
                        @[@"Poland",@"48"],@"PL",
                        @[@"Portugal",@"351"],@"PT",
                        @[@"Puerto Rico",@"1"],@"PR",
                        @[@"Qatar",@"974"],@"QA",
                        @[@"Réunion",@"262"],@"RE",
                        @[@"Romania",@"40"],@"RO",
                        @[@"Russian Federation",@"7"],@"RU",
                        @[@"Rwanda",@"250"],@"RW",
                        @[@"Saint Helena",@"290"],@"SH",
                        @[@"Saint Kitts and Nevis",@"1"],@"KN",
                        @[@"Saint Lucia",@"1"],@"LC",
                        @[@"Saint Pierre and Miquelon",@"508"],@"PM",
                        @[@"Saint Vincent and Grenadines",@"1"],@"VC",
                        @[@"Saint-Barthélemy",@"590"],@"BL",
                        @[@"Saint-Martin (French part)",@"590"],@"MF",
                        @[@"Samoa",@"685"],@"WS",
                        @[@"San Marino",@"378"],@"SM",
                        @[@"Sao Tome and Principe",@"239"],@"ST",
                        @[@"Saudi Arabia",@"966"],@"SA",
                        @[@"Senegal",@"221"],@"SN",
                        @[@"Serbia",@"381"],@"RS",
                        @[@"Seychelles",@"248"],@"SC",
                        @[@"Sierra Leone",@"232"],@"SL",
                        @[@"Singapore",@"65"],@"SG",
                        @[@"Sint Maarten",@"1"],@"SX",
                        @[@"Slovakia",@"421"],@"SK",
                        @[@"Slovenia",@"386"],@"SI",
                        @[@"Solomon Islands",@"677"],@"SB",
                        @[@"Somalia",@"252"],@"SO",
                        @[@"South Africa",@"27"],@"ZA",
                        @[@"South Georgia and the South Sandwich Islands",@"500"],@"GS",
                        @[@"South Sudan",@"211"],@"SS​",
                        @[@"Spain",@"34"],@"ES",
                        @[@"Sri Lanka",@"94"],@"LK",
                        @[@"Sudan",@"249"],@"SD",
                        @[@"Suriname",@"597"],@"SR",
                        @[@"Svalbard and Jan Mayen Islands",@"47"],@"SJ",
                        @[@"Swaziland",@"268"],@"SZ",
                        @[@"Sweden",@"46"],@"SE",
                        @[@"Switzerland",@"41"],@"CH",
                        @[@"Syrian Arab Republic (Syria)",@"963"],@"SY",
                        @[@"Taiwan, Republic of China",@"886"],@"TW",
                        @[@"Tajikistan",@"992"],@"TJ",
                        @[@"Tanzania, United Republic of",@"255"],@"TZ",
                        @[@"Thailand",@"66"],@"TH",
                        @[@"Timor-Leste",@"670"],@"TL",
                        @[@"Togo",@"228"],@"TG",
                        @[@"Tokelau",@"690"],@"TK",
                        @[@"Tonga",@"676"],@"TO",
                        @[@"Trinidad and Tobago",@"1"],@"TT",
                        @[@"Tunisia",@"216"],@"TN",
                        @[@"Turkey",@"90"],@"TR",
                        @[@"Turkmenistan",@"993"],@"TM",
                        @[@"Turks and Caicos Islands",@"1"],@"TC",
                        @[@"Tuvalu",@"688"],@"TV",
                        @[@"Uganda",@"256"],@"UG",
                        @[@"Ukraine",@"380"],@"UA",
                        @[@"United Arab Emirates",@"971"],@"AE",
                        @[@"United Kingdom",@"44"],@"GB",
                        @[@"United States of America",@"1"],@"US",
                        @[@"Uruguay",@"598"],@"UY",
                        @[@"Uzbekistan",@"998"],@"UZ",
                        @[@"Vanuatu",@"678"],@"VU",
                        @[@"Venezuela (Bolivarian Republic of)",@"58"],@"VE",
                        @[@"Viet Nam",@"84"],@"VN",
                        @[@"Virgin Islands, US",@"1"],@"VI",
                        @[@"Wallis and Futuna Islands",@"681"],@"WF",
                        @[@"Western Sahara",@"212"],@"EH",
                        @[@"Yemen",@"967"],@"YE",
                        @[@"Zambia",@"260"],@"ZM",
                        @[@"Zimbabwe",@"263"],@"ZW", nil];
    
   return [dict objectForKey:code];
}
+ (NSArray *)countryNames
{
    static NSArray *_countryNames = nil;
    if (!_countryNames)
    {
        _countryNames = [[[[self countryNamesByCode] allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] copy];
    }
    return _countryNames;
}

+ (NSArray *)countryCodes
{
    static NSArray *_countryCodes = nil;
    if (!_countryCodes)
    {
        _countryCodes = [[[self countryCodesByName] objectsForKeys:[self countryNames] notFoundMarker:@""] copy];
    }
    return _countryCodes;
}

+ (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes])
        {
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];

            //workaround for simulator bug
            if (!countryName)
            {
                countryName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
            }
 
            namesByCode[code] = countryName ?: code;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

+ (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

- (void)setUp
{
    super.dataSource = self;
    super.delegate = self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setDataSource:(__unused id<UIPickerViewDataSource>)dataSource
{
    //does nothing
}

- (void)setSelectedCountryCode:(NSString *)countryCode animated:(BOOL)animated
{
    NSUInteger index = [[[self class] countryCodes] indexOfObject:countryCode];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
    }
}

- (void)setSelectedCountryCode:(NSString *)countryCode
{
    [self setSelectedCountryCode:countryCode animated:NO];
}

- (NSString *)selectedCountryCode
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    return [[self class] countryCodes][index];
}

- (void)setSelectedCountryName:(NSString *)countryName animated:(BOOL)animated
{
    NSUInteger index = [[[self class] countryNames] indexOfObject:countryName];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
    }
}

- (void)setSelectedCountryName:(NSString *)countryName
{
    [self setSelectedCountryName:countryName animated:NO];
}

- (NSString *)selectedCountryName
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    return [[self class] countryNames][index];
}

- (void)setSelectedLocale:(NSLocale *)locale animated:(BOOL)animated
{
    [self setSelectedCountryCode:[locale objectForKey:NSLocaleCountryCode] animated:animated];
}

- (void)setSelectedLocale:(NSLocale *)locale
{
    [self setSelectedLocale:locale animated:NO];
}

- (NSLocale *)selectedLocale
{
    NSString *countryCode = self.selectedCountryCode;
    if (countryCode)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: countryCode}];
        return [NSLocale localeWithLocaleIdentifier:identifier];
    }
    return nil;
}

#pragma mark -
#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    return (NSInteger)[[[self class] countryCodes] count];
}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 245, 24)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        if (self.labelFont) {
            label.font = self.labelFont;
        }
        [view addSubview:label];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
        flagView.contentMode = UIViewContentModeScaleAspectFit;
        flagView.tag = 2;
        [view addSubview:flagView];
    }

    ((UILabel *)[view viewWithTag:1]).text = [[self class] countryNames][(NSUInteger)row];
    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", [[self class] countryCodes][(NSUInteger) row]];
    UIImage *image;
    if ([[UIImage class] respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)])
        image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:[CountryPicker class]] compatibleWithTraitCollection:nil];
    else
        image = [UIImage imageNamed:imagePath];
    ((UIImageView *)[view viewWithTag:2]).image = image;


    return view;
}

- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(__unused NSInteger)row
       inComponent:(__unused NSInteger)component
{
    __strong id<CountryPickerDelegate> strongDelegate = delegate;
    [strongDelegate countryPicker:self didSelectCountryWithName:self.selectedCountryName code:self.selectedCountryCode];
}

@end
