package com.unibuc.pao.lab6.ex2;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

public class WindowOpenedAdapter extends WindowAdapter {

    @Override
    public void windowOpened(WindowEvent e) {
        e.getWindow().setVisible(true);
    }

}
