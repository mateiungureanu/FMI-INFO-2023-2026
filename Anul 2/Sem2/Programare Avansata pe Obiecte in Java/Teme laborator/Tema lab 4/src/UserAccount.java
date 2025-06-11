public final class UserAccount {
    private final String username;
    private final String emailAddress;
    private final String password;

    public UserAccount(String username, String emailAddress, String password) {
        if (username != null && username.matches("[a-zA-Z0-9]{5,20}"))
            this.username = username;
        else
            throw new IllegalArgumentException("Invalid username");
        if (emailAddress != null &&  emailAddress.matches("[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"))
            this.emailAddress = emailAddress;
        else
            throw new IllegalArgumentException("Invalid email address");
        if (password != null &&  password.matches("(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+\\-!]).{8,}"))
            this.password = password;
        else
            throw new IllegalArgumentException("Invalid password");
    }

    public String getUsername() {
        return username;
    }

    @Override
    public String toString() {
        return "Username: " + username + ", Email address: " + emailAddress + ", Password: " + "*".repeat(password.length());
    }
}
