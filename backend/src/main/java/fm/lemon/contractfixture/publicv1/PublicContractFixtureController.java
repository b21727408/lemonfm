package fm.lemon.contractfixture.publicv1;

import fm.lemon.generated.contract.publicv1.api.ContractFixtureApi;
import fm.lemon.generated.contract.publicv1.model.ContractFixtureResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PublicContractFixtureController implements ContractFixtureApi {
  @Override
  public ResponseEntity<ContractFixtureResponse> getPublicContractFixture() {
    ContractFixtureResponse response =
        new ContractFixtureResponse(ContractFixtureResponse.FixtureEnum.PUBLIC_V1);
    return ResponseEntity.ok(response);
  }
}
