//
//  Localization.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import Foundation
import Alamofire

private protocol Localizable {
    var key: String { get }
    var value: String { get }
}

private struct Localizer {
    static func localized(key: Localizable, bundle: Bundle = .main, tableName: String = "Localizable", value: String = "", comment: String = "", param: String = "") -> String {
        let path = Bundle.main.path(forResource: "ja", ofType: "lproj")
        let bundle1 = Bundle(path: path!)
        
        let bundleUsed =  deploymentMode == .dev ? bundle : bundle1!
        let value = String(format: NSLocalizedString(key.key, tableName: tableName, bundle: bundleUsed, value: value, comment: comment), param)
        return value
    }
}

public enum LocalizedKey: Localizable {
    
    case oops
    case appName
    case cancel
    case authCancel
    case notYet
    case validRequired(String)
    case required(String)
    case loginRequired
    // register screen
    case registerAnAccount
    case registerByEmailSNS
    case registerByEmail
    case useAnSNSAccount
    case continueWithLine
    case continueOnTwitter
    case continueOnFacebook
    case continueOnInstagram
    case continueOnApple
    case dontRegisterNow
    case loginNow
    // RegisterByEmail
    case emailAddress
    case pleaseEnterYourEmailAddress
    case toRegister
    //OneTimePasswordScreen
    case oneTimePassword
    case pleaseEnterYourOTP
    case logIn
    case resendOTP
    case completeTheInput
    //RegisterPassword
    case registerPassword
    case pleaseEnterYourPassword
    case passwordNote
    // EditProfile
    case selectIcon,
         removeImage,
         removeImageWarning
    case fullName
    case informationNotPublish
    case pleaseEnterYourName
    case gender
    case requiredString
    case male
    case female
    case addGender
    case toSave
    case selectImage
    case nicknameFullCharacterOrLess
    case pleaseEnterYourNickname
    case musicalInstruments
    case pleaseEnterTheInstrumentName
    case postalCode
    case pleaseEnterYourZipCode
    case age
    case occupation
    case selfIntroduction,
         changeThePhoto,
         updateProfile,
         updateProfileSuccessful
    case settings,
         more,
         profile,
         changePassword,
         purchasedListContent,
         recordingList,
         billingHistory,
         pointPurchaseHistory,
         points,
         buyPointWarning,
         logout,
         yes,
         withdrawl,
         stramingDownload,
         recording,
         dataManagement,
         pushNotification,
         imageQualityUponLowSpeed,
         appVersionInformation,
         tutorial,
         aboutApp,
         faqContactUs,
         opinionRequest,
         officialWebsite,
         recordingEditingList,
         rec,
         suspend,
         startRecording,
         recordDescription,
         songName,
         streamingQuality,
         streamingPlaybackOverWifiOnly,
         notifyUsingMobileData,
         downloadQuality,
         downloadOverWifiOnly,
         automaticDownload,
         logoutConfirmation,
         logoutValid,
         clickForContactUs,
         clickForFAQ,
         contactUs,
         faq,
         termsOfService,
         privacyPolicy,
         notation,
         softwareLiscence,
         songLiscence,
         reviewRating,
         opinionRequestHere,
         diskFull,
         //tabb bar
         myPage,
         home,
         search,
         favourite,
         playlist,
         //home
         recommendedContent,
         seeMore,
         //page option
         conductor,
         session,
         hallSound,
         player,
         //home listing
         homeListingSearchPlaceholder,
         //onboardingg
         next,
         previous,
         completion,
         //profile
         edit,
         yourProfile,
         name,
         nickname,
         musicalInstrument,
         area,
         email,
         emailPlaceholder,
         profession,
         dateOfBirth,
         //login
         login,
         loginTitle,
         username,
         password,
         usernamePlaceholder,
         passwordPlaceholder,
         forgetPassword,
         socialLoginTitle,
         line,
         facebook,
         twitter,
         instagram,
         registerAccount,
         loginFail,
         //search
         searchPlaceholder
    // Pop alert
    case  emailRequired
    case  otpRequired
    case  emailInValid
    case  passwordRequired
    case  sessionExpired
    case  loading
    //  case  email
    case  usernameRequired
    case  genderRequired
    case  dobRequired
    case  professionRequired
    case  postalCodeRequired
    case  fullnameRequired
    case  selectProfileImage
    case  noInternet
    case  nicknameRequired
    case  errorCompressingImage
    case  ok
    case  instrumentRequired
    case  errorImageSize(String)
    case noData
    //conductor
    case composer,
         orchestraName,
         conductorTitle,
         organization,
         venueName,
         releaseDate,
         liscenceNumber,
         playTime,
         viewOrganizationChart
    //changePassword
    case  oldPassword,
          pleaseEnterPassword,
          ifYouDontKnowPassword,
          newPassword,
          newPasswordConfirm,
          change,
          oldPasswordIsRequired,
          newPasswordIsRequired,
          confirmPasswordIsRequired,
          newAndConfirmPasswordSame
    //forgotPassword
    case toReset,
         forgotPasswordTitle
    //notification
    case news
    //hall sound
    case buy,
         cannotFindBuyProduct
    //player
    case birthday,
         bloodGroup,
         birthPlace,
         instrument,
         manufacturer,
         performance,
         profileLink,
         playerMessage
    //cart
    case myCart,
         cart,
         premium,
         premiumSet,
         part,
         cancelPurchase,
         removeCartItemConfirmation,
         delete,
         checkoutConfirmation,
         checkoutSuccessMessage,
         checkoutMinError
    //BillingHistory
    case partTune,
         purchaseDate,
         year,
         month,
         date
    //recording settings
    case fileFormat,
         encodingQuality,
         samplingRate,
         bitRate,
         channel
    //data management settings
    case cacheData,
         capacityUsed,
         cacheInfo,
         deleteCache,
         deleteCacheWarning,
         downloadSongs,
         downloadComplete,
         freeSpace,
         deleteDownloadData,
         deleteDownloadWarning
    //instrument detail
    case noInstrument,
         buyPart(String),
         clickForPremiumVideo,
         buyBundle,
         playSampleVideo,
         playVideo,
         partVideoInfo,
         buyMinusOne,
         noDataFound
    //bulk instrument details
    case buyBulk,
         addAllInCart,
         purchase,
         purchased,
         addToCart,
         buyConfirmation,
         purchasedInBulk,
         addedInCart,
         moveToCartShort,
         moveToCart,
         instrumentPurchaseMinError,
         instrumentPurchaseMaxError,
         instrumentAddToCartMinError,
         songs
    //instrument detail buy
    case wouldYouBuy,
         wouldYouBuyAsSet,
         bought,
         addedToCart
    //premium video details
    case buyPremiumVideoBundle,
         premiumVideoSeperateUnpurchasable,
         returnToPartVideo,
         premiumVideo,
         clickForBonusVideo,
         premiumVideoInfo,
    buyPremiumVideo
    //instrument player
    case buyThisPart,
         whatIsPremiumVideo,
         buyThisPartStatement,
         mkvNotSupported,
//         buyPremiumVideo,
         buyPremium,
         buyMultiplePart,
         buyOtherPart,
         partPurchased,
         checkAppendixPremiumVideo,
         buyBundlePremiumConfirmation
    //withdraw
    case withdrawConfirmation,
         withdraw,
         stillWithdraw,
         withdrawn
    //iap
    case purchaseCancel,
         fetchingProduct
    //download
    case wifiDownloadOnly,
         cellularDownloadWarning,
         redownloadVideo,
         downloadInProgress,
        downloadStarted
    
    var key: String {
        switch self {
        case .oops: return "OOPS"
        case .appName: return "APP_NAME"
        case .cancel: return "CANCEL"
        case .authCancel: return "AUTH_CANCEL"
        case .notYet: return "NOT_YET"
        case .validRequired: return "VALID_REQUIRED_PREFIX"
        case .required: return "REQUIRED_PREFIX"
        case .loginRequired: return "LOGIN_REQUIRED"
            // register screen
        case .registerAnAccount: return "REGISTER_AN_ACCOUNT"
        case .registerByEmailSNS : return "REGISTER_BY_EMAIL_SNS"
        case .registerByEmail : return "REGISTER_BY_EMAIL"
        case .useAnSNSAccount : return "USE_AN_SNS_ACCOUNT"
        case .continueWithLine : return "CONTINUE_WITH_LINE"
        case .continueOnTwitter : return "CONTINUE_ON_TWITTER"
        case .continueOnFacebook : return "CONTINUE_ON_FACEBOOK"
        case .continueOnInstagram : return "CONTINUE_ON_INSTAGRAM"
        case .continueOnApple: return "CONTINUE_ON_APPLE"
        case .dontRegisterNow : return "DONT_REGISTER_NOW"
        case .loginNow : return "LOGIN_NOW"
            // RegisterByEmail
        case .emailAddress: return  "EMAIL_ADDRESS"
        case .pleaseEnterYourEmailAddress: return "PLEASE_ENTER_YOUR_EMAIL_ADDRESS"
        case .toRegister: return  "TO_REGISTER"
            //OneTimePasswordScreen
        case .oneTimePassword: return "ONE_TIME_PASSWORD"
        case .pleaseEnterYourOTP: return "PLEASE_ENTER_YOUR_OTP"
        case .logIn: return "LOG_IN"
        case .resendOTP: return "RESENT_OTP"
        case .completeTheInput: return "COMPLETE_THE_INPUT"
            //RegisterPassword
        case .registerPassword : return "REGISTER_PASSWORD"
        case .pleaseEnterYourPassword : return "PLEASE_ENTER_YOUR_PASSWORD"
        case .passwordNote : return "PASSWORD_NOTE"
            // EditProfile
        case .selectIcon: return "SELECT_ICON"
        case .removeImage: return "REMOVE_IMAGE"
        case .removeImageWarning: return "REMOVE_IMAGE_WARNING"
        case .fullName: return    "FULL_NAME"
        case .informationNotPublish: return    "INFORMATION_NOT_PUBLISHED"
        case .pleaseEnterYourName: return    "PLEASE_ENTER_YOUR_NAME"
        case .gender: return    "GENDER"
        case .requiredString: return    "REQUIRED"
        case .male: return    "MALE"
        case .female: return    "FEMALE"
        case .addGender: return    "ADD_GENDER"
        case .toSave: return    "TO_SAVE"
        case .selectImage: return "SELECT_IMAGE"
        case .nicknameFullCharacterOrLess: return    "NICKNAME_FULL_12_CHARACTER_OR_LESS"
        case .pleaseEnterYourNickname: return    "PLEASE_ENTER_YOUR_NICKNAME"
        case .musicalInstruments: return    "MUSICAL_INSTRUMENTS"
        case .pleaseEnterTheInstrumentName: return    "PLEASE_ENTER_THE_INSTRUMENT_NAME"
        case .postalCode: return "POSTAL_CODE"
        case .pleaseEnterYourZipCode: return "PLEASE_ENTER_YOUR_ZIP_CODE"
        case .age: return "AGE"
        case .occupation: return "OCCUPATION"
        case .selfIntroduction: return "SELF_INTRODUCTION"
        case .changeThePhoto: return "CHANGE_THE_PHOTO"
        case .updateProfile: return "UPDATE_PROFILE"
        case .updateProfileSuccessful: return "PROFILE_UPDATE_SUCCESSFULLY"
            //my page
        case .settings: return "SETTINGS"
        case .more: return "MORE"
        case .profile: return "PROFILE"
        case .changePassword: return "CHANGE_PASSWORD"
        case .purchasedListContent: return "PURCHASED_LIST_CONTENT"
        case .recordingList: return "RECORDING_LIST"
        case .billingHistory: return "BILLING_HISTORY"
        case .pointPurchaseHistory: return "POINT_PURCHASE_HISTORY"
        case .points: return "POINTS"
        case .buyPointWarning: return "BUY_POINT_WARNING"
        case .logout: return "LOGOUT"
        case .yes: return "YES"
        case .withdrawl: return "WITHDRAWL"
        case .stramingDownload: return "STREAMING_DOWNLOAD"
        case .recording: return "RECORDING"
        case .dataManagement: return "DATA_MANAGEMENT"
        case .pushNotification: return "PUSH_NOTIFICATION"
        case .imageQualityUponLowSpeed: return "IMAGE_QUALITY_UPON_LOW_SPEED"
        case .appVersionInformation: return "APP_VERSION_INFORMATION"
        case .tutorial: return "TUTORIAL"
        case .aboutApp: return "ABOUT_APP"
        case .faqContactUs: return "FAQ_CONTACT_US"
        case .opinionRequest: return "OPINION_REQUEST"
        case .officialWebsite: return "BRASSO_OFFICIAL_WEBSITE"
        case .recordingEditingList: return "RECORDING_EDITING_LIST"
        case .songName: return "SONG_NAME"
        case .rec: return "REC"
        case .suspend: return "SUSPEND"
        case .startRecording: return "RECORDING_START"
        case .recordDescription: return "RECORD_DESCRIPTION"
        case .streamingQuality: return "STREAMING_QUALITY"
        case .streamingPlaybackOverWifiOnly: return "STREAMING_PLAYBACK_OVER_WIFI_ONLY"
        case .notifyUsingMobileData: return "NOTIFY_USING_MOBILE_DATA"
        case .downloadQuality: return "DOWNLOAD_QUALITY"
        case .downloadOverWifiOnly: return "DOWNLOAD_OVER_WIFI_ONLY"
        case .automaticDownload: return "AUTOMATIC_DOWNLOAD"
        case .logoutConfirmation: return "LOGOUT_CONFIRMATION"
        case .logoutValid: return "LOGOUT_VALID"
        case .clickForContactUs: return "CLICK_FOR_CONTACT_US"
        case .clickForFAQ: return "CLICK_FOR_FAQ"
        case .contactUs: return "CONTACT_US"
        case .faq: return "FAQ"
        case .termsOfService: return "TERMS_OF_SERVICE"
        case .privacyPolicy: return "PRIVACY_POLICY"
        case .notation: return "NOTATION"
        case .softwareLiscence: return "SOFTWARE_LISCENCE"
        case .songLiscence: return "SONG_LISCENCE"
        case .reviewRating: return "REVIEW_RATING"
        case .opinionRequestHere: return "OPINION_REQUEST_HERE"
        case .diskFull: return "DISK_FULL"
            //tab bar
        case .home: return "HOME"
        case .myPage: return "MY_PAGE"
        case .favourite: return "FAVOURITE"
        case .search: return "SEARCH"
        case .playlist: return "PLAYLIST"
            //home
        case .recommendedContent: return "RECOMMENDED_CONTENT"
        case .seeMore: return "SEE_MORE"
            //page option
        case .conductor: return "CONDUCTOR"
        case .session: return "SESSION"
        case .hallSound: return "HALL_SOUND"
        case .player: return "PLAYER"
            //home listing
        case .homeListingSearchPlaceholder: return "HOME_LISTING_SEARCH_PLACEHOLDER"
            //onboarding
        case .next : return "NEXT"
        case .previous : return "PREVIOUS"
        case .completion: return "COMPLETION"
            //profile
        case .edit: return "EDIT"
        case .yourProfile: return "YOUR_PROFILE"
        case .name: return "NAME"
        case .nickname: return "NICKNAME"
        case .musicalInstrument: return "MUSICAL_INSTRUMENT"
        case .area: return "AREA"
        case .email: return "EMAIL"
        case .emailPlaceholder: return "EMAIL_PLACEHOLDER"
        case .profession: return "PROFESSION"
        case .dateOfBirth: return "DATE_OF_BIRTH"
            //login
        case .login: return "LOGIN"
        case .loginTitle: return "LOGIN_TITLE"
        case .username: return "USERNAME"
        case .password: return "PASSWORD"
        case .usernamePlaceholder: return "USERNAME_PLACEHOLDER"
        case .passwordPlaceholder: return "PASSWORD_PLACEHOLDER"
        case .forgetPassword: return "FORGET_PASSWORD"
        case .socialLoginTitle: return "SOCIAL_LOGIN_TITLE"
        case .line: return "LINE"
        case .facebook: return "FACEBOOK"
        case .twitter: return "TWITTER"
        case .instagram: return "INSTAGRAM"
        case .registerAccount: return "REGISTER_ACCOUNT"
        case .loginFail: return "LOGIN_FAIL"
            //search
        case .searchPlaceholder: return "SEARCH_PLACEHOLDER"
            //popAlert
        case .emailRequired: return "EMAIL_IS_REQUIRED"
        case .otpRequired: return "OTP_IS_REQUIRED"
        case .emailInValid: return "EMAIL_INVALID"
        case .passwordRequired: return "PASSWORD_IS_REQUIRED"
        case .sessionExpired: return "SESSION_EXPIRED"
        case .loading: return "LOADING"
        case .usernameRequired: return "USERNAME_IS_REQUIRED"
        case .genderRequired: return "GENDER_IS_REQUIRED"
        case .dobRequired: return "DOB_CANT_BE_EMPTY"
        case .professionRequired: return "PROFESSION_IS_REQUIRED"
        case .postalCodeRequired: return "POSTAL_CODE_IS_REQUIRED"
        case .fullnameRequired: return "FULLNAME_IS_REQUIRED"
        case .selectProfileImage: return "SELECT_PROFILE_IMAGE"
        case .noInternet: return "NO_INTERNET"
        case .nicknameRequired: return "NICKNAME_IS_REQUIRED"
        case .errorCompressingImage: return "ERROR_COMPRESSING_IMAGE"
        case .ok: return "OK"
        case .instrumentRequired: return "INSTRUMENT_CODE_IS_REQUIRED"
        case .errorImageSize: return "ERROR_IMAGE_SIZE"
        case .noData: return "NO_DATA"
            //conductor
        case .composer: return "COMPOSER"
        case .orchestraName: return "ORCHESTRA_NAME"
        case .conductorTitle: return "CONDUCTOR_TITLE"
        case .organization: return "ORGANIZATION"
        case .venueName: return "VENUE_NAME"
        case .releaseDate: return "RELEASE_DATE"
        case .liscenceNumber: return "LISCENCE_NUMBER"
        case .playTime: return "PLAY_TIME"
        case .viewOrganizationChart: return "VIEW_ORGANIZATION_CHART"
            // change password
        case .oldPassword: return "OLD_PASSWORD"
        case .pleaseEnterPassword: return "PLEASE_ENTER_PASSWORD"
        case .ifYouDontKnowPassword: return "IF_YOU_DONT_KNOW_OR_FORGOT_YOUR_PASSWORD"
        case .newPassword: return "NEW_PASSWORD"
        case .newPasswordConfirm: return "NEW_PASSWORD_CONFIRM"
        case .change: return "CHANGE"
        case .oldPasswordIsRequired: return "OLD_PASSWORD_IS_REQUIRED"
        case .newPasswordIsRequired: return  "NEW_PASSWORD_IS_REQUIRED"
        case .confirmPasswordIsRequired: return "CONFIRM_PASSWORD_IS_REQUIRED"
        case .newAndConfirmPasswordSame: return "New_AND_CONFIRM_PASSWORD_SAME"
        case .toReset: return "TO_RESET"
        case .forgotPasswordTitle: return  "FORGOT_PASSWORD"
            //notification
        case .news: return "NEWS"
            //hall sound
        case .buy: return "BUY"
        case .cannotFindBuyProduct: return "CANNOT_FIND_BUY_PRODUCT"
            //player
        case .birthday: return "BIRTHDAY"
        case .bloodGroup: return "BLOOD_GROUP"
        case .birthPlace: return "BIRTHPLACE"
        case .instrument: return "INSTRUMENT"
        case .manufacturer: return "MANUFACTURER"
        case .performance: return "PERFORMANCE"
        case .profileLink: return "PROFILE_LINK"
        case .playerMessage: return "PLAYER_MESSAGE"
            //cart
        case .myCart: return "MY_CART"
        case .cart: return "CART"
        case .premium: return "PREMIUM"
        case .premiumSet: return "PREMIUM_SET"
        case .part: return "PART"
        case .cancelPurchase: return "CANCEL_PURCHASE"
        case .removeCartItemConfirmation: return "REMOVE_CART_ITEM_CONFIRMATION"
        case .delete: return "DELETE"
        case .checkoutConfirmation: return "CHECKOUT_CONFIRMATION"
        case .checkoutSuccessMessage: return "CHECKOUT_SUCCESS_MESSAGE"
        case .checkoutMinError: return "CHECKOUT_MIN_ERROR"
            //billing history
        case .year: return "YEAR"
        case .month: return "MONTH"
        case .date: return "DATE"
        case .partTune: return "PART_TUNE"
        case .purchaseDate: return "DATE_OF_PURCHASE"
        case .fileFormat: return "FILE_FORMAT"
        case .encodingQuality: return "ENCODING_QUALITY"
        case .samplingRate: return "SAMPLING_RATE"
        case .bitRate: return "BIT_RATE"
        case .channel: return "CHANNEL"
            //data management settings
        case .cacheData: return "CACHE_DATA"
        case .capacityUsed: return "CAPACITY_USED"
        case .cacheInfo: return "CACHE_INFO"
        case .deleteCache: return "DELETE_CACHE"
        case .deleteCacheWarning: return "DELETE_CACHE_WARNING"
        case .downloadSongs: return "DOWNLOAD_SONGS"
        case .downloadComplete: return "DOWNLOAD_COMPLETE"
        case .freeSpace: return "FREE_SPACE"
        case .deleteDownloadData: return "DELETE_DOWNLOAD_DATA"
        case .deleteDownloadWarning: return "DELETE_DOWNLOAD_WARNING"
            //checkout confirmation
        case .purchase: return "PURCHASE"
            //instrument detail
        case .noInstrument: return "NO_INSTRUMENT"
        case .buyPart: return "BUY_PART"
        case .clickForPremiumVideo: return "CLICK_FOR_PREMIUM_VIDEO"
        case .buyBundle: return "BUY_BUNDLE"
        case .playSampleVideo: return "PLAY_SAMPLE_VIDEO"
        case .playVideo: return "PLAY_VIDEO"
        case .partVideoInfo: return "PART_VIDEO_INFO"
        case .buyMinusOne: return "BUY_MINUS_ONE"
        case .noDataFound: return "NO_DATA_FOUND"
            //bulk instrument details
        case .buyBulk: return "BUY_BULK"
        case .addAllInCart: return "ADD_ALL_IN_CART"
        case .purchase: return "PURCHASE"
        case .purchased: return "PURCHASED"
        case .addToCart: return "ADD_TO_CART"
        case .buyConfirmation: return "BUY_CONFIRMATION"
        case .purchasedInBulk: return "PURCHASED_IN_BULK"
        case .addedInCart: return "ADDED_IN_CART"
        case .moveToCartShort: return "MOVE_TO_CART_SHORT"
        case .moveToCart: return "MOVE_TO_CART"
        case .instrumentPurchaseMinError: return "INSTRUMENT_PURCHASE_MIN_ERROR"
        case .instrumentPurchaseMaxError: return "INSTRUMENT_PURCHASE_MAX_ERROR"
        case .instrumentAddToCartMinError: return "INSTRUMENT_ADD_TO_CART_MIN_ERROR"
        case .songs: return "SONGS"
            //instrument detail buy
        case .wouldYouBuy: return "WOULD_YOU_BUY"
        case .wouldYouBuyAsSet: return "WOULD_YOU_BUY_AS_SET"
        case .bought: return "BOUGHT"
        case .addedToCart: return "ADDED_TO_CART"
            //premium video details
        case .buyPremiumVideoBundle: return "BUY_PREMIUM_VIDEO_BUNDLE"
        case .premiumVideoSeperateUnpurchasable: return "PREMIUM_VIDEO_SEPERATE_UNPURCHASABLE"
        case .returnToPartVideo: return "RETURN_TO_PART_VIDEO"
        case .premiumVideo: return "PREMIUM_VIDEO"
        case .clickForBonusVideo: return "CLICK_FOR_BONUS_VIDEO"
        case .premiumVideoInfo : return "PREMIUM_VIDEO_INFO"
        case .buyPremiumVideo: return "BUY_PREMIUM_VIDEO"
            //instrument player
        case .buyThisPart: return "BUY_THIS_PART"
        case .whatIsPremiumVideo: return "WHAT_IS_PREMIUM_VIDEO"
        case .buyThisPartStatement: return "BUY_THIS_PART_STATEMENT"
        case .mkvNotSupported: return "MKV_NOT_SUPPORTED"
        case .buyPremiumVideo: return "BUY_PREMIUM_VIDEO"
        case .buyPremium: return "BUY_PREMIUM"
        case .buyMultiplePart: return "BUY_MULTIPLE_PART"
        case .buyOtherPart: return "BUY_OTHER_PART"
        case .partPurchased: return "PART_PURCHASED"
        case .checkAppendixPremiumVideo: return "CHECK_APPENDIX_PREMIUM_VIDEO"
        case .buyBundlePremiumConfirmation: return "BUY_BUNDLE_PREMIUM_CONFIRMATION"
            //withdraw
        case .withdrawConfirmation: return  "WITHDRAW_CONFIRMATION"
        case .withdraw: return "WITHDRAW"
        case .stillWithdraw: return "STILL_WITHDRAW"
        case .withdrawn: return "WITHDRAWN"
            //iap
        case .purchaseCancel: return "PURCHASE_CANCEL"
        case .fetchingProduct: return "FETCHING_PRODUCT"
            //download
        case .wifiDownloadOnly: return "WIFI_DOWNLOAD_ONLY"
        case .cellularDownloadWarning: return "CELLULAR_DOWNLOAD_WARNING"
        case .redownloadVideo: return "REDOWNLOAD_VIDEO"
        case .downloadInProgress: return "DOWNLOAD_IN_PROGRESS"
        case .downloadStarted: return "DOWNLOAD_STARTED"
        }
    }
    
    public var value: String {
        switch self {
        case .required(let para),
                .validRequired(let para),
                .errorImageSize(let para),
                .buyPart(let para):
            return Localizer.localized(key: self, param: para)
        default :
            return  Localizer.localized(key: self)
        }
    }
    
}
