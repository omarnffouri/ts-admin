enum Environment {
  dev('dev.ts-portal.com'),
  staging('staging.ts-portal.com'),
  production('ts-portal.com');

  final String host;
  const Environment(this.host);
}
