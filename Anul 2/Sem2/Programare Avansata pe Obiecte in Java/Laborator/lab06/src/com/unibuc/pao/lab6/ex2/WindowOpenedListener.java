package com.unibuc.pao.lab6.ex2;

import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

public class WindowOpenedListener implements WindowListener {

    @Override
    public void windowOpened(WindowEvent e) {
        e.getWindow().setVisible(true);
    }

    @Override
    public void windowClosing(WindowEvent e) {

    }

    @Override
    public void windowClosed(WindowEvent e) {

    }

    @Override
    public void windowIconified(WindowEvent e) {

    }

    @Override
    public void windowDeiconified(WindowEvent e) {

    }

    @Override
    public void windowActivated(WindowEvent e) {

    }

    @Override
    public void windowDeactivated(WindowEvent e) {

    }
}
