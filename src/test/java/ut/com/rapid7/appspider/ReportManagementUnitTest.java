package ut.com.rapid7.appspider;
import com.rapid7.appspider.Authentication;
import com.rapid7.appspider.ReportManagement;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by nbugash on 09/07/15.
 */
public class ReportManagementUnitTest extends BaseUnitTest {

    // Temporary parameters
    String restUrl = "http://ontesting.ntobjectives.com/ntoe36/rest/v1";
    String login = "wstclient";
    String password = "wstclient";
    String scanId = "9a9309e9-3ede-43a9-9edb-7fab5031003c";

//    @Test
//    public void getReportAllFiles(){
//        String authToken = Authentication.authenticate(restUrl,login,password);
//        Object response = ReportManagement.getReportAllFiles(restUrl, authToken, scanId);
//        assertEquals(response.getClass(),JSONObject.class);
//    }

    @Test
    public void getVulnerabilitiesSummaryXml(){
        String authToken = Authentication.authenticate(restUrl,login,password);
        Object response = ReportManagement.getVulnerabilitiesSummaryXml(restUrl, authToken, scanId );
        response.toString();
    }
}
