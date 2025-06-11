import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class DigitalPet {
    private final String name;
    private int hungerLevel;
    private final List<String> feedHistory = new ArrayList<>();
    private final Object lock = new Object();

    public DigitalPet(String name) {
        this.name = name;
        this.hungerLevel = 0;
    }

    public void increaseHunger() {
        synchronized (lock) {
            hungerLevel++;
        }
    }

    public void feed() {
        if (hungerLevel == 0) {
            System.out.println(name + " is not hungry right now.");
            return;
        }
        synchronized (lock) {
            hungerLevel = 0;
            String log = name + " has been fed at " + LocalDateTime.now() + ".";
            feedHistory.add(log);
            System.out.println(log);
        }
    }

    public int getHungerLevel() {
        synchronized (lock) {
            return hungerLevel;
        }
    }

    public List<String> getFeedHistory() {
        synchronized (lock) {
            return new ArrayList<>(feedHistory);
        }
    }

    public String getName() {
        return name;
    }
}