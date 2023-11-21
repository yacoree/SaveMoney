using SaveMoney.ADO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SaveMoney.DBConnection
{
    internal class DBConnect
    {
        public static SaveMoneyEntities2 connect = new SaveMoneyEntities2();
    }
}
