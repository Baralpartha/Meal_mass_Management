/// Replace these values with your actual Supabase project credentials.
/// Never commit real secrets to version control — use --dart-define or
/// a .env loader in CI/CD.
class EnvConfig {
  EnvConfig._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ezdkiepefzecosxjofxx.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_WaSAtRnmIii-x9m3xOwbEw_Eqr6Mh6n',
  );
}