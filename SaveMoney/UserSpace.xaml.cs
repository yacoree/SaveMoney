using LiveCharts;
using LiveCharts.Defaults;
using LiveCharts.Wpf;
using SaveMoney.ADO;
using SaveMoney.Core;
using SaveMoney.DBConnection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace SaveMoney
{
    public partial class UserSpace : Window
    {
        private bool isExpense = true;
        private Categories[] categories;
        private List<Categories> expenseCategories = new List<Categories>();
        private List<Categories> incomeCategories = new List<Categories>();
        public SeriesCollection ExpenseCollection { get; set; }
        public SeriesCollection IncomeCollection { get; set; }

        public UserSpace()
        {
            Generate();
        }

        private void Generate()
        {
            categories = DBConnect.connect.Categories.ToArray();
            foreach (var category in categories)
            {
                if (category.ID_TransactionTypes == 1) incomeCategories.Add(category);
                else expenseCategories.Add(category);
            }

            var categoryTransaction = DBConnect.connect.CategoriesTransactions.Where(z => z.ID_BankAccount == User.currentBankAccount).ToArray();
            SeriesCollection negative = new SeriesCollection();
            SeriesCollection positive = new SeriesCollection();
            foreach (var category in categoryTransaction)
            {
                var temp = new PieSeries
                {
                    Title = category.Name,
                    Values = new ChartValues<ObservableValue> { new ObservableValue((double)category.Amount) },
                    DataLabels = true
                };
                if (category.Amount < 0) negative.Add(temp);
                else positive.Add(temp);
            }
            ExpenseCollection = negative;
            IncomeCollection = positive;

            InitializeComponent();
            var balance = DBConnect.connect.BankAccountsAmounts.Where(z => z.BankAccount_ID == User.currentBankAccount).FirstOrDefault();
            PositiveBalance.Text = $"{balance.BankAccountAmount}";
            NegativeBalance.Text = $"{balance.BankAccountAmount}";
            List<string> names = new List<string>();
            foreach (var category in expenseCategories) names.Add(category.Name);
            CatigoriesCB.ItemsSource = names;
            ChartPositive.Series = IncomeCollection;
            Chart.Series = ExpenseCollection;
        }

        private void SaveTransaction(object sender, RoutedEventArgs e)
        {
            if (Amount.Text == null || CatigoriesCB.SelectedIndex == -1)
            {
                MessageBox.Show("All fields must be filled in", "Alert", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            try
            {
                decimal AmountTransaction = Convert.ToDecimal(Amount.Text);
                if (isExpense) AmountTransaction = -AmountTransaction;
                int comboBoxId = CatigoriesCB.SelectedIndex;
                Categories selectedCategory = isExpense? expenseCategories[comboBoxId] : incomeCategories[comboBoxId];
                
                Transactions transaction = new Transactions() {
                    ID_BankAccount = User.currentBankAccount,
                    Amount = AmountTransaction,
                    Date = (DateTime)TransactionDate.SelectedDate,
                    ID_Category = selectedCategory.Category_ID,
                };

                DBConnect.connect.Transactions.Add(transaction);
                DBConnect.connect.SaveChanges();
                Generate();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void Expense_Click(object sender, RoutedEventArgs e)
        {
            isExpense = true;
            List<string> names = new List<string>();
            foreach (var category in expenseCategories) names.Add(category.Name);
            CatigoriesCB.ItemsSource = names;
        }

        private void Income_Click(object sender, RoutedEventArgs e)
        {
            isExpense = false;
            List<string> names = new List<string>();
            foreach (var category in incomeCategories) names.Add(category.Name);
            CatigoriesCB.ItemsSource = names;
        }
    }
}
