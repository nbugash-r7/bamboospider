package ut.com.rapid7.appspider;

import com.amazonaws.util.json.JSONObject;
import com.rapid7.appspider.ScanConfiguration;
import com.rapid7.appspider.Authentication;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by nbugash on 08/07/15.
 */
public class ScanConfigurationUnitTest extends BaseUnitTest{

    @Test
    public void getConfigs(){
        String authToken = Authentication.authenticate(this.getRestUrl(),this.getUsername(),this.getPassword());
        Object configs = ScanConfiguration.getConfigs(this.getRestUrl(),authToken);
        assertEquals(JSONObject.class,configs.getClass());
    }
}
