enum GearType {
  container,
  rope,
  carabiner,
  acsender,
  decsender,
  harness,
  sling,
  ahd,
  pulleySet,
  patientTransport,
  ropeClamp,
  fallArrester,
  unspecified;

  String get supabaseValue => switch (this) {
    container => 'container',
    rope => 'rope',
    carabiner => 'carabiner',
    acsender => 'acsender',
    decsender => 'decsender',
    harness => 'harness',
    sling => 'sling',
    ahd => 'ahd',
    pulleySet => 'pulley_set',
    patientTransport => 'patient_transport',
    ropeClamp => 'rope_clamp',
    fallArrester => 'fall_arrester',
    unspecified => 'unspecified',
  };

  static GearType fromString(String val) => switch (val) {
    'container' => container,
    'rope' => rope,
    'carabiner' => carabiner,
    'acsender' => acsender,
    'decsender' => decsender,
    'harness' => harness,
    'sling' => sling,
    'ahd' => ahd,
    'pulley_set' => pulleySet,
    'patient_transport' => patientTransport,
    'rope_clamp' => ropeClamp,
    'fall_arrester' => fallArrester,
    _ => unspecified,
  };
}
