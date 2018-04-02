using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
//xml
using System.Xml;
using System.Xml.Linq;
using System.IO;
using System.Text;
//���л���json
using System.Runtime.Serialization;
using System.ServiceModel.Web;
using System.Runtime.Serialization.Json;

public partial class Footer : System.Web.UI.Page
{
    string appid = "wxb1ebabf042f6e8e3";
    string secret = "4241ffc9ad419504e762d0a26ee3f39d";
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public class UserInfo
    {
        public String openid;
        public String nickname;
        public String sex;
        public String province;
        public String city;
        public String country;
        public String headimgurl;
        public String privilege;
        public String unionid;
    }
    public class JsonHelper
    {
        public JsonHelper()
        {
            //  
            // TODO: Add constructor logic here  
            //  
        }
        /// <summary>  
        /// �Ѷ������л� JSON �ַ���   
        /// </summary>  
        /// <typeparam name="T">��������</typeparam>  
        /// <param name="obj">����ʵ��</param>  
        /// <returns>JSON�ַ���</returns>  
        public static string GetJson<T>(T obj)
        {
            //��ס ������� System.ServiceModel.Web   
            /** 
             * �����������������,System.Runtime.Serialization.Json; Json�ǳ�������Ŷ 
             * */
            DataContractJsonSerializer json = new DataContractJsonSerializer(typeof(T));
            using (MemoryStream ms = new MemoryStream())
            {
                json.WriteObject(ms, obj);
                string szJson = Encoding.UTF8.GetString(ms.ToArray());
                return szJson;
            }
        }
        /// <summary>  
        /// ��JSON�ַ�����ԭΪ����  
        /// </summary>  
        /// <typeparam name="T">��������</typeparam>  
        /// <param name="szJson">JSON�ַ���</param>  
        /// <returns>����ʵ��</returns>  
        public static T ParseFromJson<T>(string szJson)
        {
            T obj = Activator.CreateInstance<T>();
            using (MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(szJson)))
            {
                DataContractJsonSerializer dcj = new DataContractJsonSerializer(typeof(T));
                return (T)dcj.ReadObject(ms);
            }
        }
    }
}