using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace KriyaID
{
    /// <summary>
    /// Helper class providing reusable ADO.NET methods and security routines.
    /// Strictly uses parameterized queries.
    /// </summary>
    public static class DB
    {
        public static string GetConnectionString()
        {
            var connSettings = ConfigurationManager.ConnectionStrings["KriyaIDConn"];
            if (connSettings == null || string.IsNullOrWhiteSpace(connSettings.ConnectionString))
            {
                throw new InvalidOperationException("Connection string 'KriyaIDConn' not configured in Web.config.");
            }
            return connSettings.ConnectionString;
        }

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(GetConnectionString());
        }

        public static SqlParameter Param(string name, object value)
        {
            return new SqlParameter(name, value ?? DBNull.Value);
        }

        public static SqlParameter Param(string name, object value, SqlDbType dbType)
        {
            SqlParameter p = new SqlParameter(name, dbType);
            p.Value = value ?? DBNull.Value;
            return p;
        }

        public static int ExecuteNonQuery(string query, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        public static object ExecuteScalar(string query, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }

        public static DataTable GetDataTable(string query, params SqlParameter[] parameters)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        public static DataTable ExecuteQuery(string query, params SqlParameter[] parameters)
        {
            return GetDataTable(query, parameters);
        }

        public static string FormatINR(object amount)
        {
            if (amount == null || amount == DBNull.Value) return "\u20B90";
            decimal val;
            if (decimal.TryParse(amount.ToString(), out val))
            {
                return "\u20B9" + val.ToString("N0", new System.Globalization.CultureInfo("en-IN"));
            }
            return "\u20B9" + amount.ToString();
        }

        // =========================================================================
        // SECURITY & PASSWORD HASHING (SHA256 with Salt)
        // =========================================================================

        public static string GenerateSalt()
        {
            byte[] saltBytes = new byte[16];
            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return Convert.ToBase64String(saltBytes);
        }

        public static string HashPassword(string password, string salt)
        {
            if (string.IsNullOrEmpty(password)) return string.Empty;
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] combinedBytes = Encoding.UTF8.GetBytes(password + salt);
                byte[] hashBytes = sha256.ComputeHash(combinedBytes);
                return Convert.ToBase64String(hashBytes);
            }
        }

        public static bool VerifyPassword(string enteredPassword, string storedHash, string storedSalt)
        {
            if (string.IsNullOrEmpty(enteredPassword) || string.IsNullOrEmpty(storedHash) || string.IsNullOrEmpty(storedSalt))
                return false;

            string computedHash = HashPassword(enteredPassword, storedSalt);
            return string.Equals(computedHash, storedHash, StringComparison.Ordinal);
        }

        // =========================================================================
        // DATABASE AUTO-INITIALIZATION FOR ZERO MANUAL SETUP
        // =========================================================================

        public static void InitializeDatabase()
        {
            try
            {
                // Check if Users table already exists
                object count = ExecuteScalar("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users'");
                int tableCount = Convert.ToInt32(count);

                if (tableCount == 0)
                {
                    // Find Database/KriyaID.sql file
                    string appPath = HttpRuntime.AppDomainAppPath;
                    string sqlPath = Path.Combine(appPath, "Database", "KriyaID.sql");

                    if (File.Exists(sqlPath))
                    {
                        string fullScript = File.ReadAllText(sqlPath);
                        string[] batches = Regex.Split(fullScript, @"^\s*GO\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase);

                        using (SqlConnection conn = GetConnection())
                        {
                            conn.Open();
                            foreach (string batch in batches)
                            {
                                string trimmed = batch.Trim();
                                if (!string.IsNullOrEmpty(trimmed))
                                {
                                    using (SqlCommand cmd = new SqlCommand(trimmed, conn))
                                    {
                                        cmd.ExecuteNonQuery();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine("Database auto-setup exception: " + ex.Message);
            }
        }
    }
}
