package ut.com.rapid7.bamboospider;

import org.junit.Test;
import com.rapid7.bamboospider.MyPluginComponent;
import com.rapid7.bamboospider.MyPluginComponentImpl;

import static org.junit.Assert.assertEquals;

public class MyComponentUnitTest
{
    @Test
    public void testMyName()
    {
        MyPluginComponent component = new MyPluginComponentImpl(null);
        assertEquals("names do not match!", "myComponent",component.getName());
    }
}