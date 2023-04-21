package com.appbazooka.gplus;

import static android.app.PendingIntent.getActivity;

import io.flutter.embedding.engine.FlutterEngine;
import android.content.Intent;
import android.os.Bundle;
//import io.flutter.app.FlutterActivity;
import androidx.annotation.NonNull;
import android.view.WindowManager.LayoutParams;
import com.easebuzz.payment.kit.PWECouponsActivity;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import datamodels.PWEStaticDataModel;
import io.flutter.plugin.common.PluginRegistry;
import retrofit2.converter.gson.GsonConverterFactory;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.FlutterActivity;


public class MainActivity extends FlutterActivity
//        implements PluginRegistry.PluginRegistrantCallback
{
    private static final String CHANNEL = "easebuzz";
    MethodChannel.Result channel_result;
    private boolean start_payment = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(LayoutParams.FLAG_SECURE);
        GeneratedPluginRegister.registerGeneratedPlugins(getFlutterEngine());
        start_payment = true;

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        channel_result = result;
                        if (call.method.equals("payWithEasebuzz")) {
                            if (start_payment) {
                                start_payment = false;
                                startPayment(call.arguments);
                            }
                        }
                    }
                }
        );
    }

    private void startPayment(Object arguments) {
        try {
            Gson gson = new Gson();
            JSONObject parameters = new JSONObject(gson.toJson(arguments));
            Intent intentProceed = new Intent(getActivity(), PWECouponsActivity.class);
            intentProceed.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            Iterator<?> keys = parameters.keys();
            while (keys.hasNext()) {
                String value = "";
                String key = (String) keys.next();
                value = parameters.optString(key);
                if (key.equals("amount")) {
                    Double amount = new Double(parameters.optString("amount"));
                    intentProceed.putExtra(key, amount);
                } else {
                    intentProceed.putExtra(key, value);
                }
            }
            startActivityForResult(intentProceed, PWEStaticDataModel.PWE_REQUEST_CODE);
        } catch (Exception e) {
            start_payment = true;
            Map<String, Object> error_map = new HashMap<>();
            Map<String, Object> error_desc_map = new HashMap<>();
            String error_desc = "exception occured:" + e.getMessage();
            error_desc_map.put("error", "Exception");
            error_desc_map.put("error_msg", error_desc);
            error_map.put("result", PWEStaticDataModel.TXN_FAILED_CODE);
            error_map.put("payment_response", error_desc_map);
            channel_result.success(error_map);
        }
    }

    //    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (data != null) {
            if (requestCode == PWEStaticDataModel.PWE_REQUEST_CODE) {
                start_payment = true;
                JSONObject response = new JSONObject();
                Map<String, Object> error_map = new HashMap<>();
                if (data != null) {
                    String result = data.getStringExtra("result");
                    String payment_response = data.getStringExtra("payment_response");
                    try {
                        JSONObject obj = new JSONObject(payment_response);
                        response.put("result", result);
                        response.put("payment_response", obj);
                        channel_result.success(new Gson().fromJson(
                                response.toString(), new TypeToken<HashMap<String, Object>>() {
                                }.getType()
                        ));
//                        channel_result.success(.convertToMap(response));
                    } catch (Exception e) {
                        Map<String, Object> error_desc_map = new HashMap<>();
                        error_desc_map.put("error", result);
                        error_desc_map.put("error_msg", payment_response);
                        error_map.put("result", result);
                        error_map.put("payment_response", error_desc_map);
                        channel_result.success(error_map);
                    }
                } else {
                    Map<String, Object> error_desc_map = new HashMap<>();
                    String error_desc = "Empty payment response";
                    error_desc_map.put("error", "Empty error");
                    error_desc_map.put("error_msg", error_desc);
                    error_map.put("result", "payment_failed");
                    error_map.put("payment_response", error_desc_map);
                    channel_result.success(error_map);
                }
            } else {
                super.onActivityResult(requestCode, resultCode, data);
            }
        }
    }

//    @Override
//    public void registerWith(@NonNull PluginRegistry registry) {
//        GeneratedPluginRegister.registerGeneratedPlugins(new FlutterEngine(this));
//    }
}
