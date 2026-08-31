package fm.lemon.contractfixture.adminv1;

import fm.lemon.generated.contract.adminv1.api.ContractFixtureApi;
import fm.lemon.generated.contract.adminv1.model.ContractFixtureResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
public final class AdminContractFixtureController implements ContractFixtureApi {
  @Override
  public ResponseEntity<ContractFixtureResponse> getAdminContractFixture() {
    ContractFixtureResponse response =
        new ContractFixtureResponse(ContractFixtureResponse.FixtureEnum.ADMIN_V1);
    return ResponseEntity.ok(response);
  }
}
