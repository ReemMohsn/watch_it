abstract final class AppStrings {
  static const appName = 'طفرة الساينس';

  static const loggedInSuccessfully = 'تم تسجيل الدخول بنجاح';
  static const loggedOutSuccessfully = 'تم تسجيل الخروج';
  static const signIn = 'تسجيل الدخول';
  static const signOut = 'تسجيل الخروج';
  static const addVideo = 'إضافة فيديو جديد';
  static const forgotPassword = 'نسيت كلمة المرور؟';
  static const passwordRecovery = 'استعادة كلمة المرور';
  static const passwordRecoveryInstructions =
      'أدخلي بريد حساب المعلمة لنرسل رابط إعادة تعيين كلمة المرور.';
  static const sendPasswordResetLink = 'إرسال رابط الاستعادة';
  static const passwordResetEmailSent =
      'إذا كان البريد مرتبطًا بحساب، فسيصلك رابط استعادة كلمة المرور. تحققي من البريد والرسائل غير المرغوب فيها.';
  static const resetPassword = 'تعيين كلمة مرور جديدة';
  static const newPassword = 'كلمة المرور الجديدة';
  static const savePassword = 'حفظ كلمة المرور';
  static const passwordResetSuccessfully = 'تم تغيير كلمة المرور بنجاح';
  static const unableToRecoverPassword =
      'تعذر إكمال استعادة كلمة المرور. اطلبي رابطًا جديدًا وحاولي مجددًا.';
  static const invalidPasswordRecoveryLink =
      'رابط الاستعادة غير مكتمل. اطلبي رسالة جديدة وافتحي رابطها.';
  static const passwordRecoveryRequestMissing =
      'تعذر العثور على طلب الاستعادة على هذا الجهاز. اطلبي رابطًا جديدًا من التطبيق نفسه وافتحي أحدث رسالة.';
  static const passwordRecoveryRequestMismatch =
      'الرابط لا يطابق آخر طلب استعادة. اطلبي رابطًا جديدًا وافتحي أحدث رسالة.';
  static const noSessionReturned = 'تعذر إنشاء جلسة دخول. حاولي مرة أخرى.';
  static const supabaseNotConfigured = 'لم يتم إعداد اتصال Supabase بعد.';
  static const invalidYoutubeUrl = 'ضعي رابط YouTube صحيحًا';
  static const videoAddedSuccessfully = 'تمت إضافة الفيديو إلى المكتبة';
  static const videoDeletedSuccessfully = 'تم حذف الفيديو';
  static const playlists = 'قوائم التشغيل';
  static const noPlaylistsYet = 'لا توجد قوائم تشغيل بعد.';
  static const choosePlaylist = 'اختاري قائمة تشغيل أو أضيفي قائمة جديدة';
  static const newPlaylist = 'إضافة قائمة جديدة';
  static const newPlaylistName = 'اسم القائمة الجديدة';
  static const enterPlaylistName = 'اكتبي اسم القائمة الجديدة';
  static const noPlaylistVideos = 'لا توجد فيديوهات في هذه القائمة بعد.';
  static const deleteVideo = 'حذف الفيديو';
  static const deletePlaylist = 'حذف القائمة';
  static const playlistDeletedSuccessfully = 'تم حذف القائمة وفيديوهاتها';
  static const cancel = 'إلغاء';
  static const noVideosYet = 'لم تُضف فيديوهات إلى المكتبة بعد.';
  static const tryAgain = 'إعادة المحاولة';

  static const thisField = 'هذا الحقل';
  static const fullNameField = 'الاسم الكامل';
  static const email = 'البريد الإلكتروني';
  static const username = 'اسم المستخدم';
  static const phoneNumber = 'رقم الهاتف';
  static const password = 'كلمة المرور';
  static const confirmPassword = 'تأكيد كلمة المرور';
  static const enterYourFullName = 'اكتبي الاسم الكامل';
  static const fullNameMustBeAtMost80Characters =
      'يجب ألا يزيد الاسم عن 80 حرفًا';
  static const enterAValidEmailAddress = 'اكتبي بريدًا إلكترونيًا صحيحًا';
  static const enterAValidPhoneNumber = 'اكتبي رقم هاتف صحيحًا';
  static const usernameMustBeAtLeast3Characters =
      'يجب أن يتكون اسم المستخدم من 3 أحرف على الأقل';
  static const passwordMustBeAtLeast8Characters =
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
  static const passwordMustContainAtLeastOneUppercaseLetter =
      'يجب أن تحتوي كلمة المرور على حرف إنجليزي كبير';
  static const passwordMustContainAtLeastOneLowercaseLetter =
      'يجب أن تحتوي كلمة المرور على حرف إنجليزي صغير';
  static const passwordMustContainAtLeastOneNumber =
      'يجب أن تحتوي كلمة المرور على رقم';
  static const passwordMustContainAtLeastOneSpecialCharacter =
      'يجب أن تحتوي كلمة المرور على رمز خاص';
  static const passwordsDoNotMatch = 'كلمتا المرور غير متطابقتين';

  static String requiredField(String field) => '$field مطلوب';

  static String confirmPlaylistDeletion(String name) =>
      'هل تريدين حذف قائمة "$name" وجميع فيديوهاتها؟';

  static String requestFailed(Type type) => 'Request failed: $type';

  static const theSignInDetailsAreIncorrect =
      'البريد أو كلمة المرور غير صحيحة.';
  static const pleaseConfirmYourEmailBeforeSigningIn =
      'أكّدي بريدك الإلكتروني قبل الدخول.';
  static const pleaseConfirmYourPhoneNumberBeforeSigningIn =
      'أكّدي رقم الهاتف قبل الدخول.';
  static const anAccountWithThisEmailAlreadyExists =
      'يوجد حساب بهذا البريد الإلكتروني.';
  static const anAccountWithTheseDetailsAlreadyExists =
      'يوجد حساب بهذه البيانات.';
  static const pleaseChooseAStrongerPassword = 'اختاري كلمة مرور أقوى.';
  static const pleaseChooseAPasswordDifferentFromYourCurrentOne =
      'اختاري كلمة مرور مختلفة عن الحالية.';
  static const theVerificationLinkOrCodeHasExpiredRequestANewOne =
      'انتهت صلاحية رابط أو رمز التحقق. اطلبي رمزًا جديدًا.';
  static const pleaseSignInAgainToContinue = 'سجّلي الدخول مرة أخرى للمتابعة.';
  static const yourSessionHasExpiredPleaseSignInAgain =
      'انتهت جلسة الدخول. سجّلي الدخول مرة أخرى.';
  static const tooManyAttemptsPleaseTryAgainLater =
      'محاولات كثيرة. حاولي لاحقًا.';
  static const tooManyEmailsRequestedPleaseTryAgainLater =
      'طُلبت رسائل بريد كثيرة. حاولي لاحقًا.';
  static const tooManyVerificationMessagesRequestedPleaseTryAgainLater =
      'طُلبت رسائل تحقق كثيرة. حاولي لاحقًا.';
  static const theRequestTimedOutPleaseTryAgain =
      'انتهت مهلة الطلب. حاولي مرة أخرى.';
  static const thisRecordAlreadyExists = 'هذا السجل موجود بالفعل.';
  static const thisActionCouldNotBeCompletedBecauseOfRelatedRecords =
      'تعذر إكمال العملية لوجود بيانات مرتبطة.';
  static const someRequiredInformationIsMissing =
      'بعض البيانات المطلوبة ناقصة.';
  static const someProvidedInformationIsInvalid =
      'بعض البيانات المدخلة غير صحيحة.';
  static const someProvidedInformationHasAnInvalidFormat =
      'صيغة بعض البيانات المدخلة غير صحيحة.';
  static const youDoNotHavePermissionToPerformThisAction =
      'ليس لديك صلاحية لتنفيذ هذه العملية.';
  static const theRequestedDataCouldNotBeRetrievedAsExpected =
      'تعذر جلب البيانات المطلوبة.';
  static const unableToReachTheServicePleaseTryAgain =
      'تعذر الاتصال بالخدمة. تحققي من الإنترنت وحاولي مجددًا.';
  static const unableToCompleteAuthenticationPleaseTryAgain =
      'تعذر إكمال تسجيل الدخول. حاولي مجددًا.';
  static const unableToLoadOrSaveDataPleaseTryAgain =
      'تعذر تحميل أو حفظ البيانات. حاولي مجددًا.';
  static const unableToCompleteTheFileOperationPleaseTryAgain =
      'تعذرت عملية الملف. حاولي مجددًا.';
  static const unableToCompleteTheOperationPleaseTryAgain =
      'تعذر إكمال العملية. حاولي مجددًا.';
  static const theReturnedDataCouldNotBeProcessedPleaseTryAgain =
      'تعذرت معالجة البيانات المستلمة. حاولي مجددًا.';
  static const anUnexpectedErrorOccurredPleaseTryAgain =
      'حدث خطأ غير متوقع. حاولي مجددًا.';
  static const theRequestedItemCouldNotBeFound =
      'لم يتم العثور على العنصر المطلوب.';
  static const thisActionConflictsWithExistingData =
      'تتعارض هذه العملية مع بيانات موجودة.';
  static const theSubmittedDataIsTooLarge = 'حجم البيانات المرسلة كبير جدًا.';
  static const tooManyRequestsPleaseTryAgainLater =
      'طلبات كثيرة. حاولي لاحقًا.';
  static const theServiceIsTemporarilyUnavailablePleaseTryAgainLater =
      'الخدمة غير متاحة مؤقتًا. حاولي لاحقًا.';
}
