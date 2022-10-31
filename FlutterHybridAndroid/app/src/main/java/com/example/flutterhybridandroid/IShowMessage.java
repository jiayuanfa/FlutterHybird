package com.example.flutterhybridandroid;

public interface IShowMessage {
    void onShowMessage(String message);
    void sendMessage(String message,boolean useEventChannel);
}
