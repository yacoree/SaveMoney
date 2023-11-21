using SaveMoney.ADO;
using SaveMoney.Core;
using SaveMoney.DBConnection;
using System;
using System.ComponentModel.DataAnnotations;
using System.Windows;

namespace SaveMoney
{
    public partial class RegistrationPage : Window
    {
        public RegistrationPage()
        {
            InitializeComponent();
        }

        private void SignIn_Click(object sender, RoutedEventArgs e)
        {
            MainWindow mainWindow = new MainWindow();
            this.Close();
            mainWindow.Show();
        }

        private void SignUp_Click(object sender, RoutedEventArgs e)
        {
            string email = txtEmail.Text;
            string password = txtPassword.Password;
            string rpassword = txtRPassword.Password;

            if (email == null || password == null || rpassword == null)
            {
                MessageBox.Show("All fields must be filled in", "Alert", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            if (password != rpassword)
            {
                MessageBox.Show("Passwords must match", "Alert", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            var testemail = new EmailAddressAttribute();
            if (!testemail.IsValid(email))
            {
                MessageBox.Show("Incorrectly entered email", "Alert", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            try
            {
                Users newUser = new Users();

                BankAccounts bankAccount = new BankAccounts()
                {
                    Name = "Main"
                };

                Logins newLogin = new Logins()
                {
                    Email = email,
                    Password = password
                };

                newUser.Logins.Add(newLogin);
                newUser.BankAccounts.Add(bankAccount);
                DBConnect.connect.Users.Add(newUser);
                DBConnect.connect.SaveChanges();

                User.currentUser = newUser;
                User.currentBankAccount = bankAccount.BankAccount_ID;
                UserSpace space = new UserSpace();
                this.Close();
                space.Show();

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
