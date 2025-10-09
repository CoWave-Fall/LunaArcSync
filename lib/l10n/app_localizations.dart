import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @languageSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingTitle;

  /// No description provided for @languageSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageSettingSubtitle;

  /// No description provided for @importDatabaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Database'**
  String get importDatabaseTitle;

  /// No description provided for @exportDatabaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Database'**
  String get exportDatabaseTitle;

  /// No description provided for @darkModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeTitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @clearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'0.0.1'**
  String get appVersion;

  /// No description provided for @appLegalese.
  ///
  /// In en, this message translates to:
  /// **'LunaArcSync is an open-source document management and synchronization application.'**
  String get appLegalese;

  /// No description provided for @aiContentNotice.
  ///
  /// In en, this message translates to:
  /// **'This program contains content generated by generative AI. Thanks to Gemini, Claude, and DeepSeek for their assistance during development.'**
  String get aiContentNotice;

  /// No description provided for @trademarkNotice.
  ///
  /// In en, this message translates to:
  /// **'Trademark Notice:'**
  String get trademarkNotice;

  /// No description provided for @trademarkGemini.
  ///
  /// In en, this message translates to:
  /// **'• \"Gemini\" is a trademark of Google LLC'**
  String get trademarkGemini;

  /// No description provided for @trademarkClaude.
  ///
  /// In en, this message translates to:
  /// **'• \"Claude\" is a trademark of Anthropic PBC'**
  String get trademarkClaude;

  /// No description provided for @trademarkDeepSeek.
  ///
  /// In en, this message translates to:
  /// **'• \"DeepSeek\" is a trademark of DeepSeek'**
  String get trademarkDeepSeek;

  /// No description provided for @trademarkDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'• The above trademarks are owned by their respective owners, and this program does not claim ownership of these trademarks'**
  String get trademarkDisclaimer;

  /// No description provided for @appInfoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'LunaArcSync is an open-source document management and synchronization application.\n\nContributors (in no particular order):\n• Gemini\n• Claude\n• DeepSeek\n• CoWave-Fall\n\nProject Repository:\nhttps://github.com/CoWave-Fall/LunaArcSync\n\nAuthor Profile:\nhttps://github.com/CoWave-Fall/'**
  String get appInfoPlaceholder;

  /// No description provided for @viewLicenses.
  ///
  /// In en, this message translates to:
  /// **'View Licenses'**
  String get viewLicenses;

  /// No description provided for @licensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get licensesTitle;

  /// No description provided for @licensesContent.
  ///
  /// In en, this message translates to:
  /// **'Built with the following open source projects:\n\n• Flutter (BSD-3-Clause)\n• Dio (MIT)\n• flutter_bloc (MIT)\n• go_router (BSD-3-Clause)\n• image_cropper (MIT)\n• pdfx (MIT)\n• flutter_svg (MIT)\n• file_picker (MIT)\n• shared_preferences (BSD-3-Clause)\n• provider (MIT)\n• file_saver (MIT)\n• path_provider (BSD-3-Clause)\n• device_info_plus (MIT)\n• package_info_plus (MIT)\n• cunning_document_scanner (MIT)\n• image (MIT)\n• path (BSD-3-Clause)\n• bloc (MIT)\n• get_it (MIT)\n• injectable (MIT)\n• freezed_annotation (MIT)\n• json_annotation (MIT)\n• flutter_secure_storage (MIT)\n• intl (BSD-3-Clause)\n• material_tag_editor (MIT)\n• image_cropper_platform_interface (MIT)\n\nOther dependencies see pubspec.yaml'**
  String get licensesContent;

  /// No description provided for @overviewAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewAppBarTitle;

  /// No description provided for @overviewRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get overviewRecentActivity;

  /// No description provided for @logoutButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButtonTooltip;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here is a summary of your activities.'**
  String get welcomeSubtitle;

  /// No description provided for @jobsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobsPageTitle;

  /// No description provided for @loadHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Load History'**
  String get loadHistoryTooltip;

  /// No description provided for @refreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// No description provided for @deleteJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Job'**
  String get deleteJobTitle;

  /// No description provided for @deleteJobMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this job? This action cannot be undone.'**
  String get deleteJobMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @jobCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get jobCompleted;

  /// No description provided for @pdfExportCompleted.
  ///
  /// In en, this message translates to:
  /// **'PDF export completed'**
  String get pdfExportCompleted;

  /// No description provided for @ocrProcessingCompleted.
  ///
  /// In en, this message translates to:
  /// **'OCR processing completed'**
  String get ocrProcessingCompleted;

  /// No description provided for @batchExportCompleted.
  ///
  /// In en, this message translates to:
  /// **'Batch export completed'**
  String get batchExportCompleted;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @jobFailed.
  ///
  /// In en, this message translates to:
  /// **'Task failed'**
  String get jobFailed;

  /// No description provided for @pdfExportFailed.
  ///
  /// In en, this message translates to:
  /// **'PDF export failed'**
  String get pdfExportFailed;

  /// No description provided for @ocrProcessingFailed.
  ///
  /// In en, this message translates to:
  /// **'OCR processing failed'**
  String get ocrProcessingFailed;

  /// No description provided for @batchExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Batch export failed'**
  String get batchExportFailed;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @downloadingResult.
  ///
  /// In en, this message translates to:
  /// **'Downloading result file...'**
  String get downloadingResult;

  /// No description provided for @downloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'File downloaded successfully! Saved as {fileName} ({fileSize}MB)'**
  String downloadSuccess(String fileName, String fileSize);

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String downloadFailed(String error);

  /// No description provided for @jobId.
  ///
  /// In en, this message translates to:
  /// **'Job ID'**
  String get jobId;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pageId.
  ///
  /// In en, this message translates to:
  /// **'Page ID'**
  String get pageId;

  /// No description provided for @downloadResult.
  ///
  /// In en, this message translates to:
  /// **'Download Result'**
  String get downloadResult;

  /// No description provided for @loadingJobs.
  ///
  /// In en, this message translates to:
  /// **'Loading Jobs...'**
  String get loadingJobs;

  /// No description provided for @refreshingJobs.
  ///
  /// In en, this message translates to:
  /// **'Refreshing Jobs...'**
  String get refreshingJobs;

  /// No description provided for @failedToLoadJobs.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Jobs'**
  String get failedToLoadJobs;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noJobsFound.
  ///
  /// In en, this message translates to:
  /// **'No Jobs Found'**
  String get noJobsFound;

  /// No description provided for @noJobsDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any active jobs at the moment.\nAll your tasks have been completed or there are no jobs in progress.'**
  String get noJobsDescription;

  /// No description provided for @refreshJobs.
  ///
  /// In en, this message translates to:
  /// **'Refresh Jobs'**
  String get refreshJobs;

  /// No description provided for @viewJobHistory.
  ///
  /// In en, this message translates to:
  /// **'View Job History'**
  String get viewJobHistory;

  /// No description provided for @jobsInfo.
  ///
  /// In en, this message translates to:
  /// **'Jobs will appear here when you start processing documents or performing batch operations.'**
  String get jobsInfo;

  /// No description provided for @cannotDeleteQueuedJobs.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete jobs that are queued or processing. Please wait for them to complete.'**
  String get cannotDeleteQueuedJobs;

  /// No description provided for @failedToDeleteJob.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete job: {error}'**
  String failedToDeleteJob(String error);

  /// No description provided for @gridColumns.
  ///
  /// In en, this message translates to:
  /// **'Grid Columns'**
  String get gridColumns;

  /// No description provided for @columns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get columns;

  /// No description provided for @darkModeImageProcessing.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode Image Processing'**
  String get darkModeImageProcessing;

  /// No description provided for @darkModeImageProcessingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust image processing for dark mode'**
  String get darkModeImageProcessingSubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @editDocumentInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Document Info'**
  String get editDocumentInfo;

  /// No description provided for @documentTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Title'**
  String get documentTitle;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @loadingDocument.
  ///
  /// In en, this message translates to:
  /// **'Loading Document...'**
  String get loadingDocument;

  /// No description provided for @documentEmpty.
  ///
  /// In en, this message translates to:
  /// **'This document is empty. Add a page to get started!'**
  String get documentEmpty;

  /// No description provided for @switchView.
  ///
  /// In en, this message translates to:
  /// **'Switch View'**
  String get switchView;

  /// No description provided for @gridSettings.
  ///
  /// In en, this message translates to:
  /// **'Grid Settings'**
  String get gridSettings;

  /// No description provided for @exportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// No description provided for @deletePage.
  ///
  /// In en, this message translates to:
  /// **'Delete Page'**
  String get deletePage;

  /// No description provided for @movePage.
  ///
  /// In en, this message translates to:
  /// **'Move Page'**
  String get movePage;

  /// No description provided for @addPage.
  ///
  /// In en, this message translates to:
  /// **'Add Page'**
  String get addPage;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @ofPages.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofPages;

  /// No description provided for @noPagesFound.
  ///
  /// In en, this message translates to:
  /// **'No pages found'**
  String get noPagesFound;

  /// No description provided for @addFirstPage.
  ///
  /// In en, this message translates to:
  /// **'Add your first page'**
  String get addFirstPage;

  /// No description provided for @scanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// No description provided for @importImage.
  ///
  /// In en, this message translates to:
  /// **'Import Image'**
  String get importImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @documentSaved.
  ///
  /// In en, this message translates to:
  /// **'Document saved successfully'**
  String get documentSaved;

  /// No description provided for @documentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted successfully'**
  String get documentDeleted;

  /// No description provided for @pageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Page deleted successfully'**
  String get pageDeleted;

  /// No description provided for @pageMoved.
  ///
  /// In en, this message translates to:
  /// **'Page moved successfully'**
  String get pageMoved;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @aboutAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutAppBarTitle;

  /// No description provided for @errorLoadingAbout.
  ///
  /// In en, this message translates to:
  /// **'Failed to load about information'**
  String get errorLoadingAbout;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @aboutAppInfo.
  ///
  /// In en, this message translates to:
  /// **'Application Information'**
  String get aboutAppInfo;

  /// No description provided for @aboutAppName.
  ///
  /// In en, this message translates to:
  /// **'Luna Arc Sync'**
  String get aboutAppName;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get aboutContact;

  /// No description provided for @aboutGitHub.
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get aboutGitHub;

  /// No description provided for @aboutServerInfo.
  ///
  /// In en, this message translates to:
  /// **'Server Information'**
  String get aboutServerInfo;

  /// No description provided for @aboutUserAccount.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get aboutUserAccount;

  /// No description provided for @aboutClientInfo.
  ///
  /// In en, this message translates to:
  /// **'Client Information'**
  String get aboutClientInfo;

  /// No description provided for @aboutLoginStatus.
  ///
  /// In en, this message translates to:
  /// **'Login Status'**
  String get aboutLoginStatus;

  /// No description provided for @aboutChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get aboutChecking;

  /// No description provided for @aboutLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged In'**
  String get aboutLoggedIn;

  /// No description provided for @aboutNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not Logged In'**
  String get aboutNotLoggedIn;

  /// No description provided for @aboutUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get aboutUserId;

  /// No description provided for @aboutPackageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get aboutPackageName;

  /// No description provided for @aboutDeviceModel.
  ///
  /// In en, this message translates to:
  /// **'Device Model'**
  String get aboutDeviceModel;

  /// No description provided for @aboutDeviceOS.
  ///
  /// In en, this message translates to:
  /// **'Operating System'**
  String get aboutDeviceOS;

  /// No description provided for @aboutDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Information'**
  String get aboutDeviceInfo;

  /// No description provided for @aboutLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get aboutLoading;

  /// No description provided for @aboutUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get aboutUnknown;

  /// No description provided for @loginManualLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in manually once to save credentials'**
  String get loginManualLoginRequired;

  /// No description provided for @loginAutoLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Auto login failed: {error}'**
  String loginAutoLoginFailed(String error);

  /// No description provided for @loginDeleteServer.
  ///
  /// In en, this message translates to:
  /// **'Delete Server'**
  String get loginDeleteServer;

  /// No description provided for @loginDeleteServerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete server \"{serverName}\"?'**
  String loginDeleteServerConfirm(String serverName);

  /// No description provided for @loginServerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Server \"{serverName}\" deleted'**
  String loginServerDeleted(String serverName);

  /// No description provided for @loginDeleteServerFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete server: {error}'**
  String loginDeleteServerFailed(String error);

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Luna Arc Sync'**
  String get appTitle;

  /// No description provided for @appTitleCharacters.
  ///
  /// In en, this message translates to:
  /// **'Luna Arc Sync'**
  String get appTitleCharacters;

  /// No description provided for @settingsExportDatabase.
  ///
  /// In en, this message translates to:
  /// **'Export Database'**
  String get settingsExportDatabase;

  /// No description provided for @settingsExportDatabaseDescription.
  ///
  /// In en, this message translates to:
  /// **'This will export all your data, including documents, pages, settings, etc.\n\n'**
  String get settingsExportDatabaseDescription;

  /// No description provided for @settingsExportDatabaseAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'The exported data will be saved as a ZIP file, which you can import on other devices.\n\nAre you sure you want to continue?'**
  String get settingsExportDatabaseAdditionalInfo;

  /// No description provided for @settingsImportDatabase.
  ///
  /// In en, this message translates to:
  /// **'Import Database'**
  String get settingsImportDatabase;

  /// No description provided for @settingsImportDatabaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Please select the previously exported ZIP file for import.\n\n'**
  String get settingsImportDatabaseDescription;

  /// No description provided for @settingsImportDatabaseAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Note: Importing data will overwrite all data on the current device. Please ensure you have backed up important information.\n\nYou need to restart the app after import for it to take effect.\n\nAre you sure you want to continue?'**
  String get settingsImportDatabaseAdditionalInfo;

  /// No description provided for @settingsFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File too large, please select a file smaller than 100MB'**
  String get settingsFileTooLarge;

  /// No description provided for @settingsFileCorrupted.
  ///
  /// In en, this message translates to:
  /// **'Cannot read file, please ensure the file is not corrupted'**
  String get settingsFileCorrupted;

  /// No description provided for @settingsNoFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get settingsNoFileSelected;

  /// No description provided for @settingsFileSelectionError.
  ///
  /// In en, this message translates to:
  /// **'Error selecting file: {error}'**
  String settingsFileSelectionError(String error);

  /// No description provided for @settingsSavingExportFile.
  ///
  /// In en, this message translates to:
  /// **'Saving export file...'**
  String get settingsSavingExportFile;

  /// No description provided for @settingsSaveExportFile.
  ///
  /// In en, this message translates to:
  /// **'Save Export File'**
  String get settingsSaveExportFile;

  /// No description provided for @settingsSaveCancelled.
  ///
  /// In en, this message translates to:
  /// **'Save cancelled'**
  String get settingsSaveCancelled;

  /// No description provided for @settingsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export successful! File saved as {fileName} ({fileSize}MB)'**
  String settingsExportSuccess(String fileName, String fileSize);

  /// No description provided for @settingsSaveFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save file: {error}'**
  String settingsSaveFileFailed(String error);

  /// No description provided for @saveFile.
  ///
  /// In en, this message translates to:
  /// **'Save File'**
  String get saveFile;

  /// No description provided for @saveCancelled.
  ///
  /// In en, this message translates to:
  /// **'Save cancelled'**
  String get saveCancelled;

  /// No description provided for @settingsImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Import Successful'**
  String get settingsImportSuccess;

  /// No description provided for @settingsImportSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Data import successful!\n\n'**
  String get settingsImportSuccessDescription;

  /// No description provided for @settingsImportSuccessAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'To ensure all data is loaded correctly, please restart the application.\n\nAfter clicking OK, the app will close. Please manually reopen it.'**
  String get settingsImportSuccessAdditionalInfo;

  /// No description provided for @settingsRefreshPageToCompleteImport.
  ///
  /// In en, this message translates to:
  /// **'Please refresh the page to complete import'**
  String get settingsRefreshPageToCompleteImport;

  /// No description provided for @settingsExportConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'The exported data will be saved as a ZIP file, which you can import and use on other devices.\n\nAre you sure you want to continue?'**
  String get settingsExportConfirmMessage;

  /// No description provided for @settingsAppearanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance Settings'**
  String get settingsAppearanceSettings;

  /// No description provided for @settingsDisplaySettings.
  ///
  /// In en, this message translates to:
  /// **'Display Settings'**
  String get settingsDisplaySettings;

  /// No description provided for @settingsJobSettings.
  ///
  /// In en, this message translates to:
  /// **'Job Settings'**
  String get settingsJobSettings;

  /// No description provided for @settingsNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get settingsNotificationSettings;

  /// No description provided for @settingsDataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settingsDataManagement;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsPollingIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get settingsPollingIntervalLabel;

  /// No description provided for @settingsOpenSourceThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks to the following open source projects:'**
  String get settingsOpenSourceThanks;

  /// No description provided for @settingsOtherDependencies.
  ///
  /// In en, this message translates to:
  /// **'Other dependencies see pubspec.yaml file'**
  String get settingsOtherDependencies;

  /// No description provided for @settingsLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get settingsLicenseTitle;

  /// No description provided for @settingsLicenseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'License content is currently unavailable.\n\nLicense type: {licenseType}\n\nPlease visit the project homepage to view the complete license information.'**
  String settingsLicenseUnavailable(String licenseType);

  /// No description provided for @settingsAppName.
  ///
  /// In en, this message translates to:
  /// **'LunaArcSync'**
  String get settingsAppName;

  /// No description provided for @settingsProgramContributors.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get settingsProgramContributors;

  /// No description provided for @settingsAiContentNotice.
  ///
  /// In en, this message translates to:
  /// **'AI Generated Content Notice'**
  String get settingsAiContentNotice;

  /// No description provided for @settingsTechnicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Technical Information'**
  String get settingsTechnicalInfo;

  /// No description provided for @settingsPackageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get settingsPackageName;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsBuildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get settingsBuildNumber;

  /// No description provided for @settingsProjectUrl.
  ///
  /// In en, this message translates to:
  /// **'Project URL'**
  String get settingsProjectUrl;

  /// No description provided for @settingsAuthorUrl.
  ///
  /// In en, this message translates to:
  /// **'Author URL'**
  String get settingsAuthorUrl;

  /// No description provided for @settingsThemeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get settingsThemeSettings;

  /// No description provided for @settingsJobHistory.
  ///
  /// In en, this message translates to:
  /// **'Job History'**
  String get settingsJobHistory;

  /// No description provided for @settingsMaxJobHistoryRecords.
  ///
  /// In en, this message translates to:
  /// **'Max records: {count}'**
  String settingsMaxJobHistoryRecords(String count);

  /// No description provided for @settingsPollingInterval.
  ///
  /// In en, this message translates to:
  /// **'Polling Interval'**
  String get settingsPollingInterval;

  /// No description provided for @settingsPollingIntervalValue.
  ///
  /// In en, this message translates to:
  /// **'Interval: {seconds}s'**
  String settingsPollingIntervalValue(String seconds);

  /// No description provided for @settingsFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get settingsFollowSystem;

  /// No description provided for @settingsFollowSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically switch based on system settings'**
  String get settingsFollowSystemDescription;

  /// No description provided for @settingsLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get settingsLightTheme;

  /// No description provided for @settingsLightThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Always use light theme'**
  String get settingsLightThemeDescription;

  /// No description provided for @settingsDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get settingsDarkTheme;

  /// No description provided for @settingsDarkThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Always use dark theme'**
  String get settingsDarkThemeDescription;

  /// No description provided for @simpleAnimationExampleTitle.
  ///
  /// In en, this message translates to:
  /// **'Simple SVG Animation Example'**
  String get simpleAnimationExampleTitle;

  /// No description provided for @svgAnimationDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'SVG Animation Demo'**
  String get svgAnimationDemoTitle;

  /// No description provided for @svgAnimationEnableAnimation.
  ///
  /// In en, this message translates to:
  /// **'Enable Animation'**
  String get svgAnimationEnableAnimation;

  /// No description provided for @svgAnimationLogoSize.
  ///
  /// In en, this message translates to:
  /// **'Logo size: {size}px'**
  String svgAnimationLogoSize(String size);

  /// No description provided for @jobsTaskCompletedWithId.
  ///
  /// In en, this message translates to:
  /// **'{message}! Job ID: {jobId}...'**
  String jobsTaskCompletedWithId(String message, String jobId);

  /// No description provided for @documentNotLoadedCannotExport.
  ///
  /// In en, this message translates to:
  /// **'Document not loaded, cannot export'**
  String get documentNotLoadedCannotExport;

  /// No description provided for @documentEmptyCannotExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Document is empty, cannot export PDF'**
  String get documentEmptyCannotExportPdf;

  /// No description provided for @documentExportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get documentExportAsPdf;

  /// No description provided for @documentExportAsPdfDescription.
  ///
  /// In en, this message translates to:
  /// **'Will export document \"{title}\" as PDF file.\n\n'**
  String documentExportAsPdfDescription(String title);

  /// No description provided for @documentExportAsPdfAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'The document contains {pageCount} pages. The export task will be processed in the background.\n\nYou can check the export progress and results in the \"Jobs\" page.\n\nAre you sure you want to start the export?'**
  String documentExportAsPdfAdditionalInfo(String pageCount);

  /// No description provided for @documentStartExport.
  ///
  /// In en, this message translates to:
  /// **'Start Export'**
  String get documentStartExport;

  /// No description provided for @documentPdfExportTaskStarted.
  ///
  /// In en, this message translates to:
  /// **'PDF export task started! Job ID: {jobId}...'**
  String documentPdfExportTaskStarted(String jobId);

  /// No description provided for @loginWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Login to Luna Arc Sync'**
  String get loginWelcomeMessage;

  /// No description provided for @loginSelectServer.
  ///
  /// In en, this message translates to:
  /// **'Select Server'**
  String get loginSelectServer;

  /// No description provided for @loginAddServer.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get loginAddServer;

  /// No description provided for @myDocuments.
  ///
  /// In en, this message translates to:
  /// **'My Documents'**
  String get myDocuments;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get themeModeDark;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginWelcomeBack;

  /// No description provided for @loginServerAddress.
  ///
  /// In en, this message translates to:
  /// **'Server Address (IP:Port)'**
  String get loginServerAddress;

  /// No description provided for @loginServerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.100:8080'**
  String get loginServerAddressHint;

  /// No description provided for @loginServerAddressHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter IP address and port (e.g., 192.168.1.100:8080)'**
  String get loginServerAddressHelper;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginRegisterPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get loginRegisterPrompt;

  /// No description provided for @loginServerAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the server address'**
  String get loginServerAddressRequired;

  /// No description provided for @loginServerAddressInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter IP:Port format (e.g., 192.168.1.100:8080)'**
  String get loginServerAddressInvalidFormat;

  /// No description provided for @loginServerAddressInvalidParts.
  ///
  /// In en, this message translates to:
  /// **'Invalid format. Use IP:Port (e.g., 192.168.1.100:8080)'**
  String get loginServerAddressInvalidParts;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginEmailRequired;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get loginPasswordRequired;

  /// No description provided for @darkModeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode Image Processing'**
  String get darkModeSettingsTitle;

  /// No description provided for @darkModeSettingsDarkTextThreshold.
  ///
  /// In en, this message translates to:
  /// **'Dark Text Threshold'**
  String get darkModeSettingsDarkTextThreshold;

  /// No description provided for @darkModeSettingsDarkTextThresholdDescription.
  ///
  /// In en, this message translates to:
  /// **'{value} (0-255) - Lower values capture more text'**
  String darkModeSettingsDarkTextThresholdDescription(String value);

  /// No description provided for @darkModeSettingsWhiteThreshold.
  ///
  /// In en, this message translates to:
  /// **'White Threshold'**
  String get darkModeSettingsWhiteThreshold;

  /// No description provided for @darkModeSettingsWhiteThresholdDescription.
  ///
  /// In en, this message translates to:
  /// **'{value} (0-255)'**
  String darkModeSettingsWhiteThresholdDescription(String value);

  /// No description provided for @darkModeSettingsDarkenFactor.
  ///
  /// In en, this message translates to:
  /// **'Darken Factor'**
  String get darkModeSettingsDarkenFactor;

  /// No description provided for @darkModeSettingsDarkenFactorDescription.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String darkModeSettingsDarkenFactorDescription(String value);

  /// No description provided for @darkModeSettingsLightenFactor.
  ///
  /// In en, this message translates to:
  /// **'Lighten Factor'**
  String get darkModeSettingsLightenFactor;

  /// No description provided for @darkModeSettingsLightenFactorDescription.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String darkModeSettingsLightenFactorDescription(String value);

  /// No description provided for @darkModeSettingsNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Changes will apply to new image renders. Existing cached images will use the old settings.'**
  String get darkModeSettingsNote;

  /// No description provided for @darkModeSettingsResetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get darkModeSettingsResetDefaults;

  /// No description provided for @darkModeSettingsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get darkModeSettingsClose;

  /// No description provided for @clearCacheSelectTypes.
  ///
  /// In en, this message translates to:
  /// **'Select cache types to clear:'**
  String get clearCacheSelectTypes;

  /// No description provided for @clearCachePdfImages.
  ///
  /// In en, this message translates to:
  /// **'PDF Images'**
  String get clearCachePdfImages;

  /// No description provided for @clearCacheDarkModeSettings.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode Settings'**
  String get clearCacheDarkModeSettings;

  /// No description provided for @clearCacheJobHistory.
  ///
  /// In en, this message translates to:
  /// **'Job History'**
  String get clearCacheJobHistory;

  /// No description provided for @clearCacheTotalSize.
  ///
  /// In en, this message translates to:
  /// **'Total Cache Size:'**
  String get clearCacheTotalSize;

  /// No description provided for @clearCacheClearSelected.
  ///
  /// In en, this message translates to:
  /// **'Clear Selected'**
  String get clearCacheClearSelected;

  /// No description provided for @clearCacheClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearCacheClearAll;

  /// No description provided for @clearCacheSuccess.
  ///
  /// In en, this message translates to:
  /// **'Selected caches cleared successfully'**
  String get clearCacheSuccess;

  /// No description provided for @clearCacheAllSuccess.
  ///
  /// In en, this message translates to:
  /// **'All caches cleared successfully'**
  String get clearCacheAllSuccess;

  /// No description provided for @fontSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get fontSettingsTitle;

  /// No description provided for @fontSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app font'**
  String get fontSettingsSubtitle;

  /// No description provided for @fontLXGWWenKaiMono.
  ///
  /// In en, this message translates to:
  /// **'LXGW WenKai Mono'**
  String get fontLXGWWenKaiMono;

  /// No description provided for @fontSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get fontSystem;

  /// No description provided for @ocrProcessingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Processing OCR...'**
  String get ocrProcessingInProgress;

  /// No description provided for @ocrTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'OCR processing completed!'**
  String get ocrTaskCompleted;

  /// No description provided for @ocrTaskStartFailed.
  ///
  /// In en, this message translates to:
  /// **'OCR task start failed: {error}'**
  String ocrTaskStartFailed(String error);

  /// No description provided for @renderFailed.
  ///
  /// In en, this message translates to:
  /// **'Render failed'**
  String get renderFailed;

  /// No description provided for @copyAllText.
  ///
  /// In en, this message translates to:
  /// **'Copy all text'**
  String get copyAllText;

  /// No description provided for @textCopied.
  ///
  /// In en, this message translates to:
  /// **'Text copied to clipboard'**
  String get textCopied;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy text'**
  String get copyText;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @createNewDocument.
  ///
  /// In en, this message translates to:
  /// **'Create New Document'**
  String get createNewDocument;

  /// No description provided for @thisDocumentIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This document is empty. Add a page to get started!'**
  String get thisDocumentIsEmpty;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add a tag'**
  String get addTag;

  /// No description provided for @filterByTags.
  ///
  /// In en, this message translates to:
  /// **'Filter by Tags'**
  String get filterByTags;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @loadingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Loading Documents...'**
  String get loadingDocuments;

  /// No description provided for @selectFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Select from Files'**
  String get selectFromFiles;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @pagesUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Pages uploaded successfully!'**
  String get pagesUploadedSuccessfully;

  /// No description provided for @pdfUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF uploaded successfully! Processing pages...'**
  String get pdfUploadedSuccessfully;

  /// No description provided for @failedToCreateDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to create document'**
  String get failedToCreateDocument;

  /// No description provided for @theConnectErrored.
  ///
  /// In en, this message translates to:
  /// **'The connect errored'**
  String get theConnectErrored;

  /// No description provided for @cancelCreate.
  ///
  /// In en, this message translates to:
  /// **'Cancel Create'**
  String get cancelCreate;

  /// No description provided for @titleCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title cannot be empty'**
  String get titleCannotBeEmpty;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @versionHistory.
  ///
  /// In en, this message translates to:
  /// **'Version History'**
  String get versionHistory;

  /// No description provided for @viewVersionHistory.
  ///
  /// In en, this message translates to:
  /// **'View version history'**
  String get viewVersionHistory;

  /// No description provided for @noVersionHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No version history found.'**
  String get noVersionHistoryFound;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @numberOfColumns.
  ///
  /// In en, this message translates to:
  /// **'Number of Columns'**
  String get numberOfColumns;

  /// No description provided for @searchDocuments.
  ///
  /// In en, this message translates to:
  /// **'Search Documents'**
  String get searchDocuments;

  /// No description provided for @searchDocumentsPagesContent.
  ///
  /// In en, this message translates to:
  /// **'Search documents, pages, content...'**
  String get searchDocumentsPagesContent;

  /// No description provided for @startTypingToSearch.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search.'**
  String get startTypingToSearch;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get searchFailed;

  /// No description provided for @uploadingAndProcessingPdf.
  ///
  /// In en, this message translates to:
  /// **'Uploading and processing PDF...'**
  String get uploadingAndProcessingPdf;

  /// No description provided for @pdfUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'PDF upload failed'**
  String get pdfUploadFailed;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
