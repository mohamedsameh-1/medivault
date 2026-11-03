class SupabaseConfig {
  SupabaseConfig._();

  /// Supabase project URL passed via `--dart-define=SUPABASE_URL=...`
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://nsysjqgtclmjtcxsyckr.supabase.co',
  );

  /// Supabase publishable/anon key passed via `--dart-define=SUPABASE_ANON_KEY=...`
  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_l8A9gJaNj5_5iJybsVXwRg_aW8pTmpT',
  );

  /// Dedicated private storage bucket for visit images.
  static const String visitImagesBucket = 'visit-images';

  /// Default expiration duration in seconds for private signed URLs (1 hour).
  static const int signedUrlExpiresInSeconds = 3600;

  /// Returns `true` if Supabase has been supplied with non-placeholder configuration.
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
  // static bool get isConfigured =>
  //     supabaseUrl.isNotEmpty &&
  //     !supabaseUrl.contains('placeholder') &&
  //     supabasePublishableKey.isNotEmpty &&
  //     !supabasePublishableKey.contains('placeholder');
}
