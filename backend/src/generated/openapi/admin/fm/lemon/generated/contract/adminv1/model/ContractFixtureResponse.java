package fm.lemon.generated.contract.adminv1.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import org.springframework.lang.Nullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * ContractFixtureResponse
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.25.0")
public class ContractFixtureResponse {

  /**
   * Gets or Sets fixture
   */
  public enum FixtureEnum {
    ADMIN_V1("admin-v1");

    private final String value;

    FixtureEnum(String value) {
      this.value = value;
    }

    @JsonValue
    public String getValue() {
      return value;
    }

    @Override
    public String toString() {
      return String.valueOf(value);
    }

    @JsonCreator
    public static FixtureEnum fromValue(String value) {
      for (FixtureEnum b : FixtureEnum.values()) {
        if (b.value.equals(value)) {
          return b;
        }
      }
      throw new IllegalArgumentException("Unexpected value '" + value + "'");
    }
  }

  private FixtureEnum fixture;

  public ContractFixtureResponse() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public ContractFixtureResponse(FixtureEnum fixture) {
    this.fixture = fixture;
  }

  public ContractFixtureResponse fixture(FixtureEnum fixture) {
    this.fixture = fixture;
    return this;
  }

  /**
   * Get fixture
   * @return fixture
   */
  @NotNull 
  @JsonProperty("fixture")
  public FixtureEnum getFixture() {
    return fixture;
  }

  @JsonProperty("fixture")
  public void setFixture(FixtureEnum fixture) {
    this.fixture = fixture;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ContractFixtureResponse contractFixtureResponse = (ContractFixtureResponse) o;
    return Objects.equals(this.fixture, contractFixtureResponse.fixture);
  }

  @Override
  public int hashCode() {
    return Objects.hash(fixture);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ContractFixtureResponse {\n");
    sb.append("    fixture: ").append(toIndentedString(fixture)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(@Nullable Object o) {
    return o == null ? "null" : o.toString().replace("\n", "\n    ");
  }
}

