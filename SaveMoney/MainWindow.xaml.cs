using SaveMoney.Core;
using SaveMoney.DBConnection;
using System;
using System.Linq;
using System.Windows;

namespace SaveMoney
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void SignIn_Click(object sender, RoutedEventArgs e)
        {
            if (txtEmail == null || txtPassword == null)
            {
                MessageBox.Show("All fields must be filled in", "Alert", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            try
            {
                var Login = DBConnect.connect.Logins.Where(z => z.Email == txtEmail.Text && z.Password == txtPassword.Password).FirstOrDefault();
                if (Login != null)
                {
                    User.currentUser = DBConnect.connect.Users.Where(z => z.User_ID == Login.ID_User).FirstOrDefault();
                    UserSpace space = new UserSpace();
                    this.Close();
                    space.Show();
                }
            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void SignUp_Click(object sender, RoutedEventArgs e)
        {
            RegistrationPage reg = new RegistrationPage();
            this.Close();
            reg.Show();
        }
    }
}
