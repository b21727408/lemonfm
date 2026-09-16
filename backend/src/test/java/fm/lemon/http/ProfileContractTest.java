package fm.lemon.http;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SchemaValidatorsConfig;
import com.networknt.schema.SpecVersion;
import fm.lemon.http.generated.api.ProfilesApi;
import fm.lemon.http.generated.model.ProfileChange;
import fm.lemon.http.generated.model.ProfileChangeFields;
import jakarta.validation.Validation;
import java.io.File;
import java.math.BigInteger;
import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.hibernate.validator.messageinterpolation.ParameterMessageInterpolator;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestFactory;
import org.openapitools.jackson.nullable.JsonNullableModule;

class ProfileContractTest {
  private static final ObjectMapper JSON = JsonMapper.builder()
      .addModule(new JavaTimeModule()).addModule(new JsonNullableModule())
      .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS).build();
  private static final JsonNode CONTRACT = read(new ObjectMapper(new YAMLFactory()), "contracts/http/public-v1.yaml");
  private static final JsonNode FIXTURES = read(JSON, "test/fixtures/profile-wire.json");

  private static JsonNode read(ObjectMapper mapper, String path) {
    try { return mapper.readTree(new File(path)); }
    catch (Exception e) { throw new IllegalStateException(e); }
  }

  private static ObjectNode fixture(String name) { return ((ObjectNode) FIXTURES.path(name).path("payload")).deepCopy(); }

  private static Class<?> model(String name) throws ClassNotFoundException {
    return Class.forName("fm.lemon.http.generated.model." + name);
  }

  private static JsonNode roundTrip(String schema, JsonNode wire) throws Exception {
    return JSON.valueToTree(JSON.treeToValue(wire, model(schema)));
  }

  // Test-only schema validation against the untouched OAS 3.1 / JSON Schema 2020-12.
  // The future HTTP adapter must validate raw mutation input and outgoing projections.
  private static Set<?> violations(String schema, JsonNode payload) {
    ObjectNode root = JSON.createObjectNode();
    root.set("components", CONTRACT.path("components"));
    root.put("$ref", "#/components/schemas/" + schema);
    var config = SchemaValidatorsConfig.builder().formatAssertionsEnabled(true).build();
    return JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012).getSchema(root, config).validate(payload);
  }

  @TestFactory Stream<DynamicTest> expectedWirePayloads() {
    return FIXTURES.propertyStream().map(entry -> DynamicTest.dynamicTest(entry.getKey(), () -> {
      String schema = entry.getValue().path("schema").asText();
      JsonNode wire = entry.getValue().path("payload");
      assertEquals(Set.of(), violations(schema, wire));
      JsonNode emitted = roundTrip(schema, wire);
      assertEquals(wire, emitted, "Generated serialization must preserve the expected wire payload");
      assertEquals(Set.of(), violations(schema, emitted));
    }));
  }

  @Test void bothRepresentationUnionsDispatchEveryBranchAndRejectUnknown() throws Exception {
    for (String schema : new String[] {"ProfileRepresentation", "ProfileRepresentationChange"}) {
      for (String payload : new String[] {"{\"kind\":\"BLANK\"}",
          "{\"kind\":\"AVATAR\",\"avatarId\":\"avatar-example\"}",
          "{\"kind\":\"PHOTO\",\"mediaId\":\"media-example\"}"}) {
        JsonNode wire = JSON.readTree(payload);
        assertEquals(wire, roundTrip(schema, wire));
        assertEquals(Set.of(), violations(schema, wire));
      }
      assertThrows(Exception.class, () -> roundTrip(schema, JSON.readTree("{\"kind\":\"FUTURE\",\"mediaId\":\"hidden\"}")));
      assertFalse(violations(schema, JSON.readTree("{\"kind\":\"BLANK\",\"mediaId\":\"hidden\"}")).isEmpty());
    }
  }

  @Test void serverRejectsUnknownStatesAndUnexpectedMutationFields() throws Exception {
    ObjectNode change = fixture("processing");
    change.put("state", "FUTURE_ALLOWED");
    assertThrows(Exception.class, () -> roundTrip("ProfileChange", change));
    for (String field : new String[] {"nickname", "cityId", "interestIds", "promptAnswers", "representation"}) {
      ObjectNode patch = JSON.createObjectNode().putNull(field);
      assertThrows(Exception.class, () -> roundTrip("ProfileChangeFields", patch));
      assertFalse(violations("ProfileChangeFields", patch).isEmpty());
    }
    assertThrows(Exception.class, () -> roundTrip("ProfileChangeFields", JSON.readTree("{\"readiness\":\"READY\"}")));
    // Response readers tolerate additive fields; the server mutation reader stays strict.
    ObjectNode response = fixture("beforeSetup").put("futurePresentation", "new");
    var tolerant = JSON.copy().disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
    assertNotNull(tolerant.treeToValue(response, model("MyProfile")));
  }

  @Test void stateVersionStaysAnExactCanonicalDecimalString() throws Exception {
    var typed = JSON.treeToValue(fixture("processing"), ProfileChange.class);
    assertTrue(new BigInteger(typed.getStateVersion()).compareTo(BigInteger.valueOf(1L << 53)) > 0);
    try (var factory = Validation.byDefaultProvider().configure()
        .messageInterpolator(new ParameterMessageInterpolator()).buildValidatorFactory()) {
      for (String invalid : new String[] {"0", "01", "-1", "1.0", "1e3", " 1", ""}) {
        typed.setStateVersion(invalid);
        assertFalse(factory.getValidator().validate(typed).isEmpty());
        assertFalse(violations("ProfileChange", JSON.valueToTree(typed)).isEmpty());
      }
    }
    ObjectNode numeric = fixture("processing").put("stateVersion", 42);
    assertFalse(violations("ProfileChange", numeric).isEmpty(), "Validate before Jackson can coerce a number to a string");
  }

  @Test void conditionalMetadataNeedsRuntimeSchemaValidation() throws Exception {
    try (var factory = Validation.byDefaultProvider().configure()
        .messageInterpolator(new ParameterMessageInterpolator()).buildValidatorFactory()) {
      for (String state : new String[] {"PROCESSING", "AWAITING_ACKNOWLEDGEMENT", "AWAITING_REVIEW", "APPLIED", "REJECTED", "NOT_APPLIED", "CANCELED", "SUPERSEDED"}) {
        ObjectNode wire = fixture("processing");
        wire.put("state", state);
        wire.remove("changes");
        if (state.equals("APPLIED")) {
          wire.put("appliedRevision", "profile-r4").put("appliedAt", "2030-01-01T12:00:02.123456Z");
        }
        if (state.equals("REJECTED") || state.equals("NOT_APPLIED")) {
          wire.putObject("problem").put("code", state.equals("REJECTED") ? "CONTENT_NOT_ALLOWED" : "SERVICE_UNAVAILABLE");
        }
        assertEquals(Set.of(), violations("ProfileChange", roundTrip("ProfileChange", wire)), state);
        ObjectNode invalid = wire.deepCopy();
        if (state.equals("APPLIED")) invalid.remove("appliedAt");
        else invalid.put("appliedRevision", "forbidden-metadata");
        var typed = JSON.treeToValue(invalid, ProfileChange.class);
        assertTrue(factory.getValidator().validate(typed).isEmpty(), "Bean annotations do not enforce if/then");
        assertFalse(violations("ProfileChange", JSON.valueToTree(typed)).isEmpty(), state);
      }
    }
    ObjectNode nudge = fixture("nudge");
    nudge.remove("changes");
    assertFalse(violations("ProfileChange", roundTrip("ProfileChange", nudge)).isEmpty());
    nudge = fixture("nudge");
    nudge.remove("nudge");
    assertFalse(violations("ProfileChange", roundTrip("ProfileChange", nudge)).isEmpty());
    nudge = fixture("nudge");
    nudge.put("state", "AWAITING_REVIEW");
    assertFalse(violations("ProfileChange", roundTrip("ProfileChange", nudge)).isEmpty());
    for (String state : new String[] {"REJECTED", "NOT_APPLIED", "PROCESSING"}) {
      ObjectNode wire = fixture("processing").put("state", state);
      if (!state.equals("PROCESSING")) assertFalse(violations("ProfileChange", wire).isEmpty());
      wire.putObject("problem").put("code", state.equals("REJECTED") ? "SERVICE_UNAVAILABLE" : "CONTENT_NOT_ALLOWED");
      assertFalse(violations("ProfileChange", roundTrip("ProfileChange", wire)).isEmpty());
    }
  }

  @Test void validateBeforeLossyDecodingAndKeepSemanticChecksExplicit() throws Exception {
    for (String invalid : new String[] {"{}", "{\"nickname\":\"ab\"}",
        "{\"interestIds\":[\"same\",\"same\"]}", "{\"promptAnswers\":[{\"promptId\":\"p\",\"answer\":\"\"}]}"}) {
      assertFalse(violations("ProfileChangeFields", JSON.readTree(invalid)).isEmpty());
    }
    ObjectNode timestamp = fixture("processing").put("createdAt", "not-a-date");
    assertFalse(violations("ProfileChange", timestamp).isEmpty());
    ObjectNode missingNullable = fixture("beforeSetup");
    missingNullable.remove("bio");
    assertFalse(violations("MyProfile", missingNullable).isEmpty());
    // Unicode length is code points in JSON Schema, UTF-16 units in @Size.
    String supplementaryLetters = "𐐀".repeat(13);
    var patch = new ProfileChangeFields().nickname(supplementaryLetters);
    assertEquals(Set.of(), violations("ProfileChangeFields", JSON.valueToTree(patch)));
    try (var factory = Validation.byDefaultProvider().configure()
        .messageInterpolator(new ParameterMessageInterpolator()).buildValidatorFactory()) {
      assertFalse(factory.getValidator().validate(patch).isEmpty(), "@Size is insufficient for Unicode length");
    }
    // These are prose/domain constraints, deliberately not claimed as generated validation.
    assertEquals(Set.of(), violations("ProfileChangeFields", JSON.readTree("{\"nickname\":\"bad name\"}")));
    assertEquals(Set.of(), violations("MyProfile", fixture("beforeSetup").put("readiness", "READY")));
    assertEquals(Set.of(), violations("ProfileChangeFields", JSON.readTree("{\"promptAnswers\":[{\"promptId\":\"p\",\"answer\":\"a\"},{\"promptId\":\"p\",\"answer\":\"b\"}]}")));
  }

  @Test void generatedGroupingMatchesTheThinProfileAdapterBoundary() {
    Set<String> operations = Arrays.stream(ProfilesApi.class.getDeclaredMethods()).map(java.lang.reflect.Method::getName).collect(Collectors.toSet());
    Set<String> expected = CONTRACT.path("paths").propertyStream()
        .flatMap(path -> path.getValue().propertyStream())
        .filter(op -> op.getValue().path("tags").toString().equals("[\"Profiles\"]"))
        .map(op -> op.getValue().path("operationId").asText()).collect(Collectors.toSet());
    assertEquals(8, expected.size());
    assertEquals(expected, operations);
    assertTrue(Arrays.stream(ProfilesApi.class.getDeclaredMethods()).noneMatch(java.lang.reflect.Method::isDefault));
  }
}
