package inmyfit.inmyfit;

import android.os.Bundle;

//import com.amitshekhar.DebugDB;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
//    DebugDB.getAddressLog();
  }
}
