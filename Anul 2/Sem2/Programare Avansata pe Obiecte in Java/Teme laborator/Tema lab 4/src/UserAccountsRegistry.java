import java.util.ArrayList;

public class UserAccountsRegistry {
    private final ArrayList<UserAccount> userAccounts = new ArrayList<>();

    public void addUserAccount(UserAccount userAccount) {
        if (userAccounts.size() == 10) {
            throw new IllegalArgumentException("UserAccountsRegistry is full");
        }
        for (UserAccount ua : userAccounts) {
            if (ua.getUsername().equals(userAccount.getUsername())) {
                throw new IllegalArgumentException("Username already exists");
            }
        }
        userAccounts.add(userAccount);
    }

    public void printUserAccounts() {
        for (UserAccount ua : userAccounts) {
            System.out.println(ua);
        }
    }

    public static void main(String[] args) {
        UserAccountsRegistry registry = new UserAccountsRegistry();
        registry.addUserAccount(new UserAccount("username1", "username1@gmail.com", "Username1@"));
        registry.addUserAccount(new UserAccount("username2", "username2@gmail.com", "Username2@"));
        registry.addUserAccount(new UserAccount("username3", "username3@gmail.com", "Username3@"));
        registry.addUserAccount(new UserAccount("username4", "username4@gmail.com", "Username4@"));
        registry.addUserAccount(new UserAccount("username5", "username5@gmail.com", "Username5@"));
        registry.addUserAccount(new UserAccount("username6", "username6@gmail.com", "Username6@"));
        registry.addUserAccount(new UserAccount("username7", "username7@gmail.com", "Username7@"));
        registry.addUserAccount(new UserAccount("username8", "username8@gmail.com", "Username8@"));
        registry.addUserAccount(new UserAccount("username9", "username9@gmail.com", "Username9@"));
        registry.addUserAccount(new UserAccount("username10", "username10@gmail.com", "Username10@"));
//        registry.addUserAccount(new UserAccount("username11", "username11@gmail.com", "Username11@"));
        registry.printUserAccounts();
    }
}
