package ut.com.rapid7.appspider;
import com.rapid7.appspider.*;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by nbugash on 08/07/15.
 */
public class AuthenticationUnitTest {

    private static String restUrl = "http://ontesting.ntobjectives.com/ntoe36/rest/v1";
    private static String username = "wstclient";
    private static String password = "wstclient";

    @Test
    public void authenticate(){
        Object authToken = Authentication.authenticate(restUrl,username,password);
        assertEquals(String.class, authToken.getClass());
    }
}
