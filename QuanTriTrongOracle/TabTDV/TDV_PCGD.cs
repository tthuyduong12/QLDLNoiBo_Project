﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace QuanTriTrongOracle.TabTDV
{
    public partial class TDV_PCGD : UserControl
    {
        OracleConnection con = new OracleConnection(new connect().getString());

        public TDV_PCGD()
        {
            InitializeComponent();
            updateGrid();
        }

        private void updateGrid()
        {
            con.Open();
            OracleCommand getEmps = con.CreateCommand();
            getEmps.CommandText = "SELECT * FROM ADMINQL.VIEW_TRUONG_DV_PHANCONGGIANGDAY";
            getEmps.CommandType = CommandType.Text;
            OracleDataReader empDR = getEmps.ExecuteReader();
            DataTable empDT = new DataTable();
            empDT.Load(empDR);
            dataGridView1.DataSource = empDT;
            con.Close();
        }

    }

}