package fm.lemon.contractfixture;

import static com.atlassian.oai.validator.mockmvc.OpenApiValidationMatchers.openApi;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import fm.lemon.contractfixture.adminv1.AdminContractFixtureController;
import fm.lemon.contractfixture.publicv1.PublicContractFixtureController;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

final class ContractFixtureResponseTest {
  private static final Path CONTRACTS =
      Path.of("..", "contracts", "fixtures", "http").toAbsolutePath();

  @Test
  void publicFixtureResponseConformsToAuthoredSpecification() throws Exception {
    MockMvc mvc = MockMvcBuilders.standaloneSetup(new PublicContractFixtureController()).build();
    mvc.perform(get("/v1/_contract/fixture"))
        .andExpect(status().isOk())
        .andExpect(openApi().isValid(CONTRACTS.resolve("public-v1.fixture.yaml").toString()));
  }

  @Test
  void adminFixtureResponseConformsToAuthoredSpecification() throws Exception {
    MockMvc mvc = MockMvcBuilders.standaloneSetup(new AdminContractFixtureController()).build();
    mvc.perform(get("/admin/v1/_contract/fixture"))
        .andExpect(status().isOk())
        .andExpect(openApi().isValid(CONTRACTS.resolve("admin-v1.fixture.yaml").toString()));
  }
}
