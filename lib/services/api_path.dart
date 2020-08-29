class APIPath {
  //firestore path 맨앞에 / 필요 없음
  static String job(String uid, String jobId) => '/users/$uid/jobs/$jobId';
  static String jobs(String uid) => '/users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      '/users/$uid/entries/$entryId';
  static String entries(String uid) => '/users/$uid/entries';
}
