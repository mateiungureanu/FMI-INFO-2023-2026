public class HungerThread extends Thread {
    private final DigitalPet pet;
    private final int maxHunger;
    private final int warningHunger;

    public HungerThread(DigitalPet pet, int warningHunger, int maxHunger) {
        this.pet = pet;
        this.warningHunger = warningHunger;
        this.maxHunger = maxHunger;
    }

    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()) {
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                break;
            }
            pet.increaseHunger();
            int hunger = pet.getHungerLevel();
            if (hunger >= warningHunger && hunger < maxHunger) {
                System.out.println("Warning: " + pet.getName() + " is hungry! (level " + hunger + ")");
            }
            if (hunger >= maxHunger) {
                System.out.println("ALERT: " + pet.getName() + " is suffering from hunger!");
            }
        }
    }
}