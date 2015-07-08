package ut.com.rapid7.appspider;
import com.rapid7.appspider.*;
import org.junit.Test;
/**
 * Created by nbugash on 08/07/15.
 */
public class BaseUnitTest {
    private static String restUrl = "http://ontesting.ntobjectives.com/ntoe36/rest/v1";
    private static String username = "wstclient";
    private static String password = "wstclient";

    public static String getRestUrl() {
        return restUrl;
    }

    public static String getUsername() {
        return username;
    }

    public static String getPassword() {
        return password;
    }
}
