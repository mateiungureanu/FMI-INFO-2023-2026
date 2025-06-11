public class Main {
    public static void main(String[] args) {
        DigitalPet pet = new DigitalPet("Tom");
        HungerThread hungerThread = new HungerThread(pet, 3, 5);
        FeedThread feedThread = new FeedThread(pet);

        hungerThread.start();
        feedThread.start();

        try {
            Thread.sleep(30000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        hungerThread.interrupt();
        feedThread.interrupt();

        System.out.println("Feed history:");
        for (String log : pet.getFeedHistory()) {
            System.out.println(log);
        }
    }
}