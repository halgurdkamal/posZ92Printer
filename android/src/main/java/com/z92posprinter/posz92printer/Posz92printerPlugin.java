package com.z92posprinter.posz92printer;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.Layout;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


import com.google.zxing.BarcodeFormat;
import com.zcs.sdk.DriverManager;
import com.zcs.sdk.Printer;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.print.PrnStrFormat;
import com.zcs.sdk.print.PrnTextFont;
import com.zcs.sdk.print.PrnTextStyle;

import java.nio.charset.StandardCharsets;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Posz92printerPlugin
 */
public class Posz92printerPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Activity activity;
    private Result mResult;

    private DriverManager mDriverManager;
    private Printer mPrinter;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "posz92printer");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        mDriverManager = DriverManager.getInstance();
        mPrinter = mDriverManager.getPrinter();
        int printStatus = mPrinter.getPrinterStatus();
        if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
            Toast.makeText(activity, "Out of paper", Toast.LENGTH_SHORT).show();
            result.success(false);
            return;
        }
        if (call.method.equals("printText")) {
            try {
                final Map<String, Object> getData = call.arguments();
                String text = (String) getData.get("text");
                boolean isBold = (boolean) getData.get("isBold");
                int alignment = (int) getData.get("Alignment");
                int fontSize = (int) getData.get("fontSize");
                printText(text, fontSize, isBold, alignment);

                result.success(true);
            } catch (Exception e) {
                result.success(false);
                return;
            }
        } else if (call.method.equals("printSpace")) {
            try {
                final Map<String, Object> getData = call.arguments();
                int lineNumber = (int) getData.get("space");
                printSpace(lineNumber);
                result.success(true);
            } catch (Exception e) {
                result.success(false);
                return;
            }
        } else if (call.method.equals("print2Column")) {
            final Map<String, Object> getData = call.arguments();
            String leftText = (String) getData.get("leftText");
            String rightText = (String) getData.get("rightText");
            boolean isBold = (boolean) getData.get("isBold");
            int fontSize = (int) getData.get("fontSize");
            int leftSize = (int) getData.get("leftTextSize");
            int rightSize = (int) getData.get("rightTextSize");
            print2Column(
                    leftText, leftSize, rightText, rightSize, fontSize, isBold
            );
            result.success(true);
        } else if (call.method.equals("print3Column")) {
            final Map<String, Object> getData = call.arguments();
            String leftText = (String) getData.get("leftText");
            String middleText = (String) getData.get("centerText");
            String rightText = (String) getData.get("rightText");
            boolean isBold = (boolean) getData.get("isBold");
            int fontSize = (int) getData.get("fontSize");
            int leftSize = (int) getData.get("leftTextSize");
            int middleSize = (int) getData.get("centerTextSize");
            int rightSize = (int) getData.get("rightTextSize");
            print3Column(
                    leftText, leftSize, middleText, middleSize, rightText, rightSize, fontSize, isBold
            );
            result.success(true);
        } else if (call.method.equals("printQrCode")) {
            final Map<String, Object> getData = call.arguments();

            String qrCode = (String) getData.get("text");
            int height = (int) getData.get("height");
            int width = (int) getData.get("width");
            printQRCode(qrCode, height, width);
            result.success(true);
        } else if (call.method.equals("printLine")) {
            final Map<String, Object> getData = call.arguments();
            String lineStyle = (String) getData.get("lineStyle");
            int lineSize = (int) getData.get("lineSize");
            int fontSize = (int) getData.get("fontSize");
            int alignment = (int) getData.get("Alignment");
            boolean isBold = (boolean) getData.get("isBold");
            printLine(lineStyle, lineSize, fontSize, isBold, alignment);
            result.success(true);
        }  else if(call.method.equals("printImageBitmap")) {
            final Map<String, Object> getData = call.arguments();

            byte[] path = (byte[]) getData.get("pathImage");


           Bitmap bitmap = BitmapFactory.decodeByteArray(path, 0, path.length);

            printBitmap(bitmap);
            result.success(true);
        }
        else if(call.method.equals("printBarCode128")) {
            final Map<String, Object> getData = call.arguments();
            String text = (String) getData.get("text");
            int height = (int) getData.get("height");
            int width = (int) getData.get("width");
            printBarCode128(text,height,width);
            result.success(true);
        }
         else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void printBarCode128(String barcodeString, int height, int width) {
        int printStatus = mPrinter.getPrinterStatus();
        if (printStatus != SdkResult.SDK_PRN_STATUS_PAPEROUT) {
            mPrinter.setPrintAppendBarCode(activity.getApplicationContext(), barcodeString, height, width, true, Layout.Alignment.ALIGN_CENTER, BarcodeFormat.CODE_128);
            printStatus = mPrinter.setPrintStart();
        }
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        return false;
    }

    public boolean printText(String text, int fontSize, boolean isBold, int alignment) {
        try {
            PrnStrFormat format = new PrnStrFormat();
            format.setFont(PrnTextFont.MONOSPACE);


            format.setTextSize(fontSize);
            if (alignment == 0) {
                format.setAli(Layout.Alignment.ALIGN_CENTER);
            } else if (alignment == 1) {
                format.setAli(Layout.Alignment.ALIGN_NORMAL);
            } else {
                format.setAli(Layout.Alignment.ALIGN_OPPOSITE);
            }
            if (isBold) {
                format.setStyle(PrnTextStyle.BOLD);
            } else {
                format.setStyle(PrnTextStyle.NORMAL);
            }
            mPrinter.setPrintAppendString(text, format);
            mPrinter.setPrintStart();
            return true;
        } catch (Exception e) {
            return false;
        }

    }

    public boolean printSpace(int lineNumber) {
        try {
            PrnStrFormat format = new PrnStrFormat();
            for (int i = 0; i < lineNumber; i++) {
                mPrinter.setPrintAppendString("", format);
            }
            mPrinter.setPrintStart();
            return true;
        } catch (Exception e) {
            return false;
        }

    }

    //
//    public boolean printImage(Bitmap bitmap) {
//        try {
//            mPrinter.setPrintAppendBitmap(bitmap, Layout.Alignment.ALIGN_NORMAL);
//            mPrinter.setPrintStart();
//            return true;
//        } catch (Exception e) {
//            return false;
//        }
//
//    }
//


    public boolean printQRCode(String qrCodeString, int height, int width) {
        try {
            mPrinter.setPrintAppendQRCode(qrCodeString, height, width, Layout.Alignment.ALIGN_CENTER);
            mPrinter.setPrintStart();
            return true;
        } catch (Exception e) {
            return false;
        }

    }


    // print 2 column
    public boolean print2Column(String leftText, int leftSize, String rightText, int rightSize, int fontSize, boolean isBold) {
        try {
            PrnStrFormat format = new PrnStrFormat();
            format.setFont(PrnTextFont.SANS_SERIF);
            format.setAli(Layout.Alignment.ALIGN_NORMAL);

            if (isBold) {
                format.setStyle(PrnTextStyle.BOLD);
            } else {
                format.setStyle(PrnTextStyle.NORMAL);
            }
            mPrinter.setPrintAppendString(String.format("%-" + leftSize + "s" + "%" + rightSize + "s", leftText, rightText), format);

            mPrinter.setPrintStart();
            return true;
        } catch (Exception e) {
            return false;
        }

    }


    public String center(String text, int len) {

        int before = (len - text.length()) / 2;
        if (before == 0)
            return String.format("%-" + len + "s", text);
        int rest = len - before;
        return String.format("%" + before + "s%-" + rest + "s", "", text);
    }

    // print 3 column
    public boolean print3Column(String leftText, int leftSize, String middleText, int middleSize, String rightText, int rightSize, int fontSize, boolean isBold) {
        try {
            PrnStrFormat format = new PrnStrFormat();
            format.setFont(PrnTextFont.SANS_SERIF);
            format.setAli(Layout.Alignment.ALIGN_NORMAL);

            if (isBold) {
                format.setStyle(PrnTextStyle.BOLD);
            } else {
                format.setStyle(PrnTextStyle.NORMAL);
            }
            String formattedString = String.format("%" + middleSize + "s", middleText);
            int sideSize = 0;
            if(leftText.length() >= rightText.length()){
                sideSize = leftText.length();
            } else {
                sideSize = rightText.length();
            }
            int padding = (middleSize - middleText.length()) / 2;
            String formatString = "%" + padding + "s%s%" + padding + "s";
            String s = String.format(formatString, "", middleText, "");

            Log.d("Debug", "print3Column: "+s.length() + " :: "+s.replace("  ","--"));
            mPrinter.setPrintAppendString(String.format("%-" + leftSize + "s"  + s + "%" + rightSize + "s %n", leftText, rightText), format);

            mPrinter.setPrintStart();
            return true;
        } catch (Exception e) {
            return false;
        }

    }

    // print line ----
    public boolean printLine(String lineStyle, int lineSize, int fontSize, boolean isBold, int alignment) {
        try {
            PrnStrFormat format = new PrnStrFormat();
            format.setFont(PrnTextFont.SANS_SERIF);
            format.setTextSize(fontSize);
            if (alignment == 0) {
                format.setAli(Layout.Alignment.ALIGN_CENTER);
            } else if (alignment == 1) {
                format.setAli(Layout.Alignment.ALIGN_NORMAL);
            } else {
                format.setAli(Layout.Alignment.ALIGN_OPPOSITE);
            }
            if (isBold) {
                format.setStyle(PrnTextStyle.BOLD);
            } else {
                format.setStyle(PrnTextStyle.NORMAL);
            }
            String line = "";
            for (int i = 0; i < lineSize; i++) {
                line += lineStyle;
            }
            mPrinter.setPrintAppendString(line, format);
            mPrinter.setPrintStart();
            return true;
        } catch (Exception e) {
            return false;
        }

    }

     private void printBitmap(Bitmap bitmap) {
       try {
            mPrinter.setPrintAppendBitmap(bitmap, Layout.Alignment.ALIGN_CENTER);
            mPrinter.setPrintStart();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}

