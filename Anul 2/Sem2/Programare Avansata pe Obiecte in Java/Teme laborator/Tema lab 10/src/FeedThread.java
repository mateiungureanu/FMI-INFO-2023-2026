public class FeedThread extends Thread {
    private final DigitalPet pet;

    public FeedThread(DigitalPet pet) {
        this.pet = pet;
    }

    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()) {
            try {
                Thread.sleep(7000);
            } catch (InterruptedException e) {
                break;
            }
            pet.feed();
        }
    }
}